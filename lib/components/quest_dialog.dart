import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levlin/components/sole_heatmap.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/models/quest.dart';
import 'package:levlin/theme/theme_colors.dart';
import 'package:provider/provider.dart';

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(
    RegExp(' +'),
    ' ',
  ).split(' ').map((str) => str.toCapitalized).join(' ');
}

class QuestDialog extends StatefulWidget {
  final int index;
  const QuestDialog({super.key, required this.index});

  @override
  State<QuestDialog> createState() => _QuestDialogState();
}

class _QuestDialogState extends State<QuestDialog> {
  @override
  void initState() {
    Provider.of<QuestDatabase>(context, listen: false).readQuests();
    Provider.of<QuestDatabase>(context, listen: false).readPlayer();
    super.initState();
  }

  void editQuest(Quest quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(content: Text("Edit Quest")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questDatabase = context.watch<QuestDatabase>();
    List<Quest> currentQuests = questDatabase.currentQuests;
    final quest = currentQuests[widget.index];
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(12),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quest.name.toCapitalized,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                      color: context.onSurface,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, color: context.onSurface),
                  ),
                ],
              ),
              SoleHeatMap(
                startDate: DateTime.now().subtract(Duration(days: 52 * 7)),
                datasets: {
                  for (var item in quest.completions) item.day: item.progress,
                },
                itemGoal: quest.goal,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: context.onSurface,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Edit Quest",
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: context.surface,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.edit, color: context.surface),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit:
                          BoxFit
                              .scaleDown, // scales the whole container when necessary
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: context.onSurface,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Stats",
                              style: GoogleFonts.roboto(fontSize: 16),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.trending_up_rounded,
                              color: context.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
