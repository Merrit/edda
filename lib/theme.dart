import 'package:flutter/material.dart';

class EddaTheme {
  static ThemeData dark = ThemeData(
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
        headline6:
            TextStyle(color: Color.fromRGBO(255, 255, 255, 0.80), fontSize: 25),
      ),
    ),
  );
}
