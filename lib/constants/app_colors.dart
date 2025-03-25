import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFF4DB6AC);
  static const Color secondary = Color(0xFF26A69A);
  static const Color accent = Color(0xFF80CBC4);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
