import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Show confirmation dialog
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        ),
      );

      if (shouldLogout ?? false) {
        await constants.authServices.signOut(context: context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to logout. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: const Text(
          'Market Flea',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text('Customer Home Page'),
      ),
    );
  }
}
