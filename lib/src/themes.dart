import 'package:flutter/material.dart';

class AppTheme {
  static const ThemeMode themeMode = ThemeMode.system;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFEEF3FC),
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    cardColor: const Color(0xFFEEF3FC),
    iconTheme: const IconThemeData(
      color: Colors.black87,
    ),
    primaryColorLight: Colors.black12,
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff424242),
      centerTitle: true,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    primaryColorLight: Colors.white10,
  );
}
