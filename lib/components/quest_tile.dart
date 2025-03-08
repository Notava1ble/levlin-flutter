import 'package:flutter/material.dart';

class QuestTile extends StatelessWidget {
  final String questName;
  final int questGoal;
  final int questProgress;
  const QuestTile({
    super.key,
    required this.questName,
    required this.questGoal,
    required this.questProgress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text("$questGoal, $questName, $questProgress"));
  }
}
