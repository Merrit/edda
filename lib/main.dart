// Standard Library
import 'package:flutter/material.dart';

// Reader Packages
import 'package:reader/library/library_screen.dart';
import 'package:reader/settings/settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reader',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontSize: 28,
            color: Color.fromRGBO(255, 255, 255, 0.80),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Color(0xFF05668D), //Colors.deepPurple[900],
          centerTitle: true,
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.80), fontSize: 25),
          ),
        ),
      ),
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
