import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:levlin/models/player.dart';
import 'package:levlin/models/quest.dart';
import 'package:path_provider/path_provider.dart';

class QuestDatabase extends ChangeNotifier {
  static late Isar isar;

  // Initialize database
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([QuestSchema, PlayerSchema], directory: dir.path);
  }

  /*

  C R U D operations

  */

  // list of quests
  final List<Quest> currentQuests = [];

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
}
