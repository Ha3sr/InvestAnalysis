import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  static final mainTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      button: const TextStyle(fontSize: 18),
      headline6: const TextStyle(color: Colors.white),
      caption: TextStyle(color: Colors.white.withOpacity(0.8)),
      subtitle1: const TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        hintStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(
            borderSide: BorderSide(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(14)))),
    colorScheme: ColorScheme.light(
        primary: const Color(0xff079D53),
        secondary: Colors.grey.shade900,
        onSecondary: Colors.white),
  );
}
