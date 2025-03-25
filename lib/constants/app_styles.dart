import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';

class AppStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    color: AppColors.textLight,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static final BoxDecoration formContainerDecoration = BoxDecoration(
    color: AppColors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.black.withOpacity(0.1),
        blurRadius: 10,
        spreadRadius: 5,
      ),
    ],
  );

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
  );
}
