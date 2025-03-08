import 'package:flutter/material.dart';
import 'package:levlin/database/quest_database.dart';
import 'package:levlin/pages/add_page.dart';
import 'package:levlin/pages/home_page.dart';
import 'package:levlin/pages/settings_page.dart';
import 'package:levlin/theme/theme_colors.dart';
import 'package:levlin/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await QuestDatabase.init();
  await QuestDatabase.createPlayer();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => QuestDatabase()),
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Levlin", style: TextStyle(color: context.onSurface)),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: context.surface,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),

          child: BottomNavigationBar(
            selectedItemColor: context.onSurface,
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
