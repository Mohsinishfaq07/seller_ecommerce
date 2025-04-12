import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/providers/splash_screen_provider.dart';
import 'package:flutter_application_1/utils/screen_utils.dart';
import 'package:flutter_application_1/view/auth/login_page.dart';
import 'package:flutter_application_1/view/customer/home_page/customer_home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeHomeScreen extends ConsumerWidget {
  const WelcomeHomeScreen({Key? key}) : super(key: key);

  void _navigateToSignUp(BuildContext context) {
    Future.delayed(const Duration(seconds: 6), () {
      if (context.mounted) {
        FirebaseAuth auth = FirebaseAuth.instance;
        if (auth.currentUser != null) {
          constants.globalFunctions.nextScreenReplace(
            context,
            const CustomerHomePage(),
          );
        } else {
          constants.globalFunctions.nextScreenReplace(
            context,
            const CustomerLoginScreen(),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenUtils().init(context);

    // Initialize navigation
    _navigateToSignUp(context);

    // Initialize animation controller
    ref.watch(splashControllerProvider);

    // Get current opacity value
    final opacity = ref.watch(splashOpacityProvider);

    return Scaffold(
      body: Container(
        height: ScreenUtils.screenHeight,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: opacity,
            child: Column(
              children: [
                SizedBox(height: ScreenUtils.getProportionateScreenHeight(40)),
                // Logo section
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_rounded,
                        size: ScreenUtils.getProportionateScreenWidth(100),
                        color: AppColors.white,
                      ),
                      SizedBox(
                        height: ScreenUtils.getProportionateScreenHeight(20),
                      ),
                      const Text(
                        'Market Flea',
                        style: AppStyles.headingStyle,
                      ),
                    ],
                  ),
                ),
                // Loading indicator
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.white),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
