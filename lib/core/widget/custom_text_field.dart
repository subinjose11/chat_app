import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPasswordField;
  final Icon? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPasswordField = false,
    this.prefixIcon,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true; // Initially, password is hidden

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // 12px border radius
        border: Border.all(color: Colors.grey, width: 1), // Border color and width
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4), // Padding inside the box
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPasswordField ? _obscureText : false, // Dynamically set obscureText
        decoration: InputDecoration(
          hintText: widget.hintText, // Custom hint text
          border: InputBorder.none, // Remove the default TextField border
          contentPadding: const EdgeInsets.symmetric(vertical: 15), // Ensure content aligns properly
          prefixIcon: widget.prefixIcon, // Add the prefix icon here
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
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
