import 'package:flutter/material.dart';
import 'package:chat_app/core/styles/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPasswordField;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPasswordField = false,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Initially, password is hidden

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // 12px border radius
        border: Border.all(
          color: isDark ? AppColors.gray700 : Colors.grey,
          width: 1,
        ), // Border color and width
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4), // Padding inside the box
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPasswordField ? _obscureText : false, // Dynamically set obscureText
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        style: TextStyle(
          color: isDark ? AppColors.white : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText, // Custom hint text
          hintStyle: TextStyle(
            color: isDark ? AppColors.gray500 : AppColors.textHint,
          ),
          border: InputBorder.none, // Remove the default TextField border
          contentPadding: const EdgeInsets.symmetric(vertical: 15), // Ensure content aligns properly
          prefixIcon: widget.prefixIcon, // Add the prefix icon here
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: isDark ? AppColors.gray400 : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle the visibility
                    });
                  },
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
