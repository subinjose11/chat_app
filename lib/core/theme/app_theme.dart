import 'package:flutter/material.dart';

// Light theme
final lightTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor: Colors.white, // Body background for light theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white, // Light theme AppBar color
    foregroundColor: Colors.black, // Light theme AppBar text/icon color
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white, // Light theme BottomNavBar background
    selectedItemColor: Colors.blue, // Selected item color
    unselectedItemColor: Colors.black54, // Unselected item color
  ),
);

// Dark theme
final darkTheme = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
).copyWith(
  scaffoldBackgroundColor: Colors.black, // Body background for dark theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // Dark theme AppBar color
    foregroundColor: Colors.white, // Dark theme AppBar text/icon color
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black, // Dark theme BottomNavBar background
    selectedItemColor: Colors.deepPurpleAccent, // Selected item color
    unselectedItemColor: Colors.grey, // Unselected item color
  ),
);
