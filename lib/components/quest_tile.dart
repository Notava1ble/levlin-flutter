import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestTile extends StatelessWidget {
  final String questName;
  final int questGoal;
  final int questProgress;
  final void Function()? onAdd;
  final void Function()? onRemove;
  final void Function()? showQuestInfo;
  const QuestTile({
    super.key,
    required this.questName,
    required this.questGoal,
    required this.questProgress,
    required this.onAdd,
    required this.onRemove,
    required this.showQuestInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: showQuestInfo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$questProgress",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "/$questGoal $questName",
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: onAdd, icon: Icon(Icons.add, size: 32)),
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.remove, size: 32),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
