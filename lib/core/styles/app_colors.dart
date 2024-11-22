import 'dart:math';
import 'dart:ui';

class AppColors {
  static const primaryColor = Color(0xff0169EB);
  static const primary900 = Color(0xff0169EB);
  static const primary700 = Color(0xff3487EF);
  static const secondaryColor = Color(0xff529BF6);
  static const dotGrayColor = Color(0xffD2D6DB);
  static const primary000 = Color(0xffE6F0FD);
  static const primary100 = Color(0xffCCE1FB);
  static const primary200 = Color(0xffB3D2F9);
  static const almostWhite = Color(0xFFF9F5FF);
  static const gray50 = Color(0x40F9FAFB);
  static const pinkPale = Color(0xffFDE7F3);
  static const dragHandleColor = Color(0xffD2D6DB);
  static const pinkHot = Color(0xffE7128B);
  static const scaffoldBackground = Color(0xff529BF6);
  static const gray400 = Color(0xff9DA4AE);
  static const pureBlack = Color(0xff000000);
  static const addRecipientGray = Color(0xff475467);
  static const navyB1 = Color(0xff09223F);
  static const navyB2 = Color(0xff1E4B61);
  static const gray100 = Color(0xffF3F4F6);
  static const red = Color(0xffDC3545);
  static const gray300 = Color(0xffD2D6DB);
  static const gray200 = Color(0xffE5E7EB);
  static const gray700 = Color(0xff475467);
  static const subTextGray = Color(0xff475467);
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
