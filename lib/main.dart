import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/pages/add_page.dart';
import 'package:levlin/pages/home_page.dart';
import 'package:levlin/pages/settings_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuestDatabase.init();
  await QuestDatabase.createPlayer();
  await QuestDatabase.createSettings();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QuestDatabase()..readSettings(),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questDatabase = context.watch<QuestDatabase>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<QuestDatabase>(context).theme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _selectedIndex == 0
                ? "Levlin"
                : _selectedIndex == 1
                ? "Create Quest"
                : "Settings",
            style: GoogleFonts.poppins(
              color: questDatabase.theme.colorScheme.onSurface,
              fontSize: 36,
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: questDatabase.theme.colorScheme.surface,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),

          child: BottomNavigationBar(
            selectedItemColor: questDatabase.theme.colorScheme.onSurface,
            backgroundColor: questDatabase.theme.colorScheme.surface,
            unselectedItemColor: questDatabase.theme.colorScheme.primary,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [HomePage(), AddPage(), SettingsPage()],
        ),
      ),
    );
  }
}
