import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';

// RN Auto garage Light Theme
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: AppColors.primaryBlue,
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundLight,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryLight,
    surface: AppColors.white,
    error: AppColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBackgroundLight,
    elevation: 2,
    shadowColor: AppColors.gray300.withOpacity(0.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.primaryBlue,
    unselectedItemColor: AppColors.gray500,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: AppColors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.gray100,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  fontFamily: 'Roboto',
);

// RN Auto garage Dark Theme
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryBlue,
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryBlue,
    secondary: AppColors.primaryLight,
    surface: AppColors.cardBackgroundDark,
    error: AppColors.error,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.cardBackgroundDark,
    foregroundColor: AppColors.white,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.white),
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.white,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBackgroundDark,
    elevation: 2,
    shadowColor: AppColors.pureBlack.withOpacity(0.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.cardBackgroundDark,
    selectedItemColor: AppColors.primaryBlue,
    unselectedItemColor: AppColors.gray500,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: AppColors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.gray800,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  fontFamily: 'Roboto',
);
