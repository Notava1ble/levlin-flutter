import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/theme/dark_mode.dart';
import 'package:levlin/theme/theme_colors.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    Provider.of<QuestDatabase>(context, listen: false).readQuests();
    Provider.of<QuestDatabase>(context, listen: false).readPlayer();
    Provider.of<QuestDatabase>(context, listen: false).readPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final questDatabase = context.watch<QuestDatabase>();
    final ThemeData theme = questDatabase.theme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Dark Mode", style: GoogleFonts.roboto(fontSize: 20)),
              CupertinoSwitch(
                value: theme == darkMode,
                onChanged:
                    (value) => context.read<QuestDatabase>().toggleTheme(),
              ),
            ],
          ),

          // Separate Debug Settings
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 12),
            height: 2,
            decoration: BoxDecoration(color: context.primary),
          ),

          // DEBUG settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  context.read<QuestDatabase>().addXp(10);
                },
                child: Text(
                  "Add 10 xp",
                  style: TextStyle(color: context.onSurface),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  context.read<QuestDatabase>().addXp(100);
                },
                child: Text(
                  "Add 100 xp",
                  style: TextStyle(color: context.onSurface),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  context.read<QuestDatabase>().addXp(1000);
                },
                child: Text(
                  "Add 1000 xp",
                  style: TextStyle(color: context.onSurface),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
