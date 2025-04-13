import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/providers/splash_screen_provider.dart';
import 'package:flutter_application_1/seller_home.dart';
import 'package:flutter_application_1/utils/screen_utils.dart';
import 'package:flutter_application_1/view/admin/admin_home/admin_home.dart';
import 'package:flutter_application_1/view/auth/login_page.dart';
import 'package:flutter_application_1/view/customer/customer_bottom_navigationbar.dart';
import 'package:flutter_application_1/view/seller/seller_home/seller_home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);
  Future<void> _navigateToSignUp(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(seconds: 6), () async {
      if (context.mounted) {
        if (user != null) {
          try {
            final DocumentSnapshot userData = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();
            if (userData.exists) {
              final userTypeString =
                  userData.get('userType'); // Get the string value
              final userType = UserType.values.firstWhere(
                (e) => e.toString() == userTypeString,
                orElse: () => UserType.customer, // Default to customer
              );
              if (userType == UserType.customer) {
                constants.globalFunctions.nextScreenReplace(
                  context,
                  const CustomerBottomNavigationBar(),
                );
              } else if (userType == UserType.seller) {
                constants.globalFunctions.nextScreenReplace(
                  context,
                  const SellerNewHomePage(),
                );
              } else if (userType == UserType.admin) {
                constants.globalFunctions.nextScreenReplace(
                  context,
                  const AdminHomePage(),
                );
              }
            }
          } catch (e) {
            print(e);
          }
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
