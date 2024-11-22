import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget appWidget;
  final double height;
  final double extraTopPadding;

  const CustomAppBar({
    super.key,
    required this.appWidget,
    this.height = kToolbarHeight,
    this.extraTopPadding = 0.0,
  });

  @override
  Size get preferredSize => Size.fromHeight(height + extraTopPadding);

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;

    if (Platform.isAndroid) {
      topPadding += extraTopPadding + 10.0;
    }

    return Container(
      padding: EdgeInsets.only(
        top: topPadding,
        left: 16.0,
        right: 16.0,
        bottom: 10.0,
      ),
      alignment: Alignment.center,
      height: height + topPadding + 10.0,
      child: appWidget,
    );
  }
}
