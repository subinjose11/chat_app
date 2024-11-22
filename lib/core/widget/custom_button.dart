import 'package:chat_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Adjust the value for more/less curve
        ),
      ),
      child: Text(
        text,
        style: subText14SB,
      ),
    );
  }
}
