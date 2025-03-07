import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levlin/components/xp_bar.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/theme/theme_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Levlin", style: TextStyle(color: context.onSurface)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: context.surface,
      body: Center(
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
                ),
              ),
            ),
            XpBar(xpObtained: xp, xpNeeded: xpNeeded),
            MaterialButton(
              onPressed: () {
                context.read<QuestDatabase>().addXp(5);
              },
              child: Text("Debug add 5 xp"),
            ),
          ],
        ),
      ),
    );
  }
}
