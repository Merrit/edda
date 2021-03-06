// Standard Library
import 'package:flutter/material.dart';

// Edda Packages
import 'package:edda/library/library_screen.dart';
import 'package:edda/settings/settings_screen.dart';
import 'package:edda/theme.dart';

void main() {
  // debugPrintGestureArenaDiagnostics = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edda',
      theme: EddaTheme.dark,
      // themeMode.system not working for desktop currently,
      // so dark theme is hard-coded for now to save my eyes.
      routes: {
        LibraryScreen.id: (context) => LibraryScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        // TODO: Passing arguments to a named route seemed
        // annoying, need to look into it more.
        // BookScreen.id: (context) => BookScreen(),
      },
      initialRoute: LibraryScreen.id,
      debugShowCheckedModeBanner: false,
    );
  }
}
