import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:levlin/models/player.dart';
import 'package:levlin/models/quest.dart';
import 'package:levlin/models/settings.dart';
import 'package:levlin/theme/dark_mode.dart';
import 'package:levlin/theme/light_mode.dart';
import 'package:levlin/utils/utils.dart';
import 'package:path_provider/path_provider.dart';

class QuestDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      QuestSchema,
      PlayerSchema,
      SettingsSchema,
    ], directory: dir.path);
  }

  // Create Player
  static Future<void> createPlayer() async {
    final existingPlayer = await isar.players.where().findFirst();
    if (existingPlayer == null) {
      final Player createdPlayer =
          Player()
            ..level = 1
            ..xp = 0;
      await isar.writeTxn(() => isar.players.put(createdPlayer));
    }
  }

  // Create Settings
  static Future<void> createSettings() async {
    final existingSettings = await isar.settings.where().findFirst();
    if (existingSettings == null) {
      final Settings createdSettings = Settings()..theme = "light";
      await isar.writeTxn(() => isar.settings.put(createdSettings));
    }
  }

  /*

    S E T T I N G S

  */

  ThemeData theme = lightMode;
  Future<void> readSettings() async {
    Settings settings = (await isar.settings.where().findFirst())!;
    if (settings.theme == "light") {
      theme = lightMode;
    } else {
      theme = darkMode;
    }

    notifyListeners();
  }

  Future<void> toggleTheme() async {
    Settings settings = (await isar.settings.where().findFirst())!;
    await isar.writeTxn(() async {
      if (settings.theme == "light") {
        settings.theme = "dark";
      } else {
        settings.theme = "light";
      }
      isar.settings.put(settings);
    });

    readSettings();
  }

  /*

  C R U D operations

  */

  // list of quests and player data
  final List<Quest> currentQuests = [];
  int level = 1;
  int xp = 0;
  int xpNeeded = 0;
  DateTime? lastTimeCompleted;

  // Read Player XP and LEVEL
  Future<void> readPlayer() async {
    List<Player> fetchedPlayers = await isar.players.where().findAll();
    level = fetchedPlayers[0].level;
    xp = fetchedPlayers[0].xp;
    xpNeeded = getNeededXpFromLevel(level + 1);

    lastTimeCompleted = fetchedPlayers[0].lastTimeCompleted;

    notifyListeners();
  }

  // Add XP
  Future<void> addXp(int amount) async {
    Player player = (await isar.players.where().findFirst())!;
    await isar.writeTxn(() async {
      int newXp = player.xp + amount;
      if (newXp >= xpNeeded) {
        while (newXp >= xpNeeded) {
          player.level += 1;
          newXp -= xpNeeded;
          xpNeeded = getNeededXpFromLevel(player.level + 1);
        }
      }
      player.xp = newXp;
      isar.players.put(player);
    });

    readPlayer();
  }

  // Create a new quest
  Future<void> addQuest(
    String questName,
    String questType,
    int questGoal,
  ) async {
    final newQuest =
        Quest()
          ..name = questName
          ..type = questType
          ..goal = questGoal;
    await isar.writeTxn(() => isar.quests.put(newQuest));
    readQuests();
  }

  // Read all quests
  Future<void> readQuests() async {
    // fetch all quests from the database
    List<Quest> fetchedQuests = await isar.quests.where().findAll();
    currentQuests.clear();
    currentQuests.addAll(fetchedQuests);

    // update the UI
    notifyListeners();
  }

  // Delete a quest
  Future<void> deleteQuest(int id) async {
    await isar.writeTxn(() async {
      await isar.quests.delete(id);
    });
    readQuests();
  }

  // Increment Quest Progress for today
  Future<void> incrementProgressToday(int questId, int amount) async {
    final quest = await isar.quests.get(questId);

    if (quest == null) return; // quest not found, exit early

    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    bool found = false;

    for (var entry in quest.completions) {
      if (isSameDay(entry.day, today)) {
        entry.progress += amount;
        found = true;
        break;
      }
    }

    if (!found) {
      // convert completions to a mutable list and add new day completion
      quest.completions = List.from(quest.completions)..add(
        DayCompletion()
          ..day = today
          ..progress = amount,
      );
    } else {
      // reassign completions to a new list so Isar detects the change
      quest.completions = List.from(quest.completions);
    }

    await isar.writeTxn(() async {
      await isar.quests.put(quest);
    });

    readQuests();
    if (areAllTasksCompletedToday(currentQuests) &&
        lastTimeCompleted != today) {
      Player player = (await isar.players.where().findFirst())!;
      await isar.writeTxn(() async {
        player.lastTimeCompleted = today;
        isar.players.put(player);
      });
      readPlayer();
      addXp((sqrt(currentQuests.length) * pow(level / 2, 2) + 50).round());
    }
  }

  // Decrement Quest Progress for today
  Future<void> decrementProgressToday(int questId, int amount) async {
    final quest = await isar.quests.get(questId);

    if (quest == null) return; // quest not found, exit early

    DateTime today = DateTime.now();

    for (var entry in quest.completions) {
      if (isSameDay(entry.day, today)) {
        int progress = entry.progress - amount;
        int limit = quest.goal > entry.progress ? 0 : quest.goal;
        if (progress >= limit) {
          entry.progress = progress;
          quest.completions = List.from(quest.completions);
        }
        break;
      }
    }

    await isar.writeTxn(() async {
      await isar.quests.put(quest);
    });

    readQuests();
  }
}
