import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/theme/dark_mode.dart';
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
    return Center(
      child: CupertinoSwitch(
        value: theme == darkMode,
        onChanged: (value) => context.read<QuestDatabase>().toggleTheme(),
      ),
    );
  }
}
