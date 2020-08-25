// Standard Library
import 'package:flutter/material.dart';

// Reader Packages
import 'package:reader/library/library_screen.dart';
import 'package:reader/settings/settings_screen.dart';
import 'package:reader/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reader',
      theme: EddaTheme.dark,
      // themeMode.system not working for desktop currently,
      // so dark theme is hard-coded for now to save my eyes.
      routes: {
        Library.id: (context) => Library(),
        SettingsScreen.id: (context) => SettingsScreen(),
      },
      initialRoute: Library.id,
      debugShowCheckedModeBanner: false,
    );
  }
}
