import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFBB86FC),
    secondary: Color(0xFF03DAC6),
    surface: Color(0xFF1E1E1E),
    error: Colors.redAccent,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white70,
    onError: Colors.white,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color.fromARGB(255, 131, 95, 147),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFBB86FC),
    foregroundColor: Colors.black,
  ),

  cardTheme: const CardTheme(
    color: Color(0xFF1E1E1E),
    elevation: 2,
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFBB86FC),
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF323232),
    contentTextStyle: TextStyle(color: Colors.white),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1F1F1F),
    border: OutlineInputBorder(),
    labelStyle: TextStyle(color: Colors.white70),
  ),

  iconTheme: const IconThemeData(color: Colors.white70),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
);
