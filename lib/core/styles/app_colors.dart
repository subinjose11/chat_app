import 'dart:math';
import 'dart:ui';

class AppColors {
  // AutoTrack Pro Primary Colors
  static const primaryBlue = Color(0xff1E88E5); // Main blue #1E88E5
  static const primaryColor = Color(0xff1E88E5);
  static const primaryDark = Color(0xff1565C0);
  static const primaryLight = Color(0xff42A5F5);
  
  // Status Colors
  static const success = Color(0xff4CAF50);
  static const warning = Color(0xffFF9800);
  static const error = Color(0xffF44336);
  static const info = Color(0xff2196F3);
  
  // Gray Scale
  static const white = Color(0xFFFFFFFF);
  static const gray50 = Color(0xFFFAFAFA);
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFEEEEEE);
  static const gray300 = Color(0xFFE0E0E0);
  static const gray400 = Color(0xFFBDBDBD);
  static const gray500 = Color(0xFF9E9E9E);
  static const gray600 = Color(0xFF757575);
  static const gray700 = Color(0xFF616161);
  static const gray800 = Color(0xFF424242);
  static const gray900 = Color(0xFF212121);
  static const pureBlack = Color(0xff000000);
  
  // Background Colors
  static const scaffoldBackgroundLight = Color(0xFFF5F7FA);
  static const scaffoldBackgroundDark = Color(0xFF121212);
  static const cardBackgroundLight = Color(0xFFFFFFFF);
  static const cardBackgroundDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textHint = Color(0xFFBDBDBD);
  
  // Legacy colors (keeping for compatibility)
  static const red = Color(0xffDC3545);
  static const subTextGray = Color(0xff757575);
}

Color stringToColor(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  int colorValue = int.parse(hexColor, radix: 16);
  return Color(colorValue);
}

String getRandomColor() {
  final materialColors = [
    "#F44336", // Red
    "#E91E63", // Pink
    "#9C27B0", // Purple
    "#673AB7", // Deep Purple
    "#3F51B5", // Indigo
    "#2196F3", // Blue
    "#03A9F4", // Light Blue
    "#00BCD4", // Cyan
    "#009688", // Teal
    "#4CAF50", // Green
    "#8BC34A", // Light Green
    "#CDDC39", // Lime
    "#FFEB3B", // Yellow
    "#FFC107", // Amber
    "#FF9800", // Orange
    "#FF5722", // Deep Orange
    "#795548", // Brown
    "#9E9E9E", // Grey
    "#607D8B" // Blue Grey
  ];
  final random = Random();
  return materialColors[random.nextInt(materialColors.length)];
}
