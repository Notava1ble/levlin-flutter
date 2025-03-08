import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levlin/components/quest_tile.dart';
import 'package:levlin/components/xp_bar.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/models/quest.dart';
import 'package:levlin/theme/theme_colors.dart';
import 'package:levlin/utils/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<QuestDatabase>(context, listen: false).readQuests();
    Provider.of<QuestDatabase>(context, listen: false).readPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final questDatabase = context.watch<QuestDatabase>();
    final int level = questDatabase.level;
    final int xp = questDatabase.xp;
    final int xpNeeded = questDatabase.xpNeeded;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              "$level",
              style: GoogleFonts.poppins(
                fontSize: 96,
                fontWeight: FontWeight.w800,
                color: context.onSurface,
              ),
            ),
          ),
          XpBar(xpObtained: xp, xpNeeded: xpNeeded),
          _buildQuestList(),
        ],
      ),
    );
  }

  Widget _buildQuestList() {
    final questDatabase = context.watch<QuestDatabase>();
    List<Quest> currentQuests = questDatabase.currentQuests;
    return ListView.builder(
      padding: EdgeInsets.only(top: 36),
      itemCount: currentQuests.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final Quest quest = currentQuests[index];
        final int progressToday = getProgressForToday(quest);
        return QuestTile(
          questName: quest.name,
          questGoal: quest.goal,
          questProgress: progressToday,
          onAdd: () {
            context.read<QuestDatabase>().incrementProgressToday(quest.id, 10);
          },
          onRemove: () {
            context.read<QuestDatabase>().decrementProgressToday(quest.id, 10);
          },
        );
      },
    );
  }
}
