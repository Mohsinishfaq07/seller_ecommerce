import 'dart:developer';

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final IconData? sufficon;
  final bool isPassword;
  final GestureTapCallback? hidepass;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final int? maxLines;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.sufficon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
    this.isEnabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.hidepass
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      enabled: isEnabled,
      maxLines: maxLines,
      validator: validator,
      
      onChanged: onChanged,
      decoration: InputDecoration(
        suffix: GestureDetector(
          onTap: () {
            hidepass!();
log("tapped");
          },
          child: Icon(sufficon)),
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF00897B)),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFF00897B))
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00897B)),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
