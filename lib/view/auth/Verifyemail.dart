import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/view/admin/admin_home/admin_home.dart';
import 'package:flutter_application_1/view/customer/home_page/customer_home.dart';

class VerifyemailPage extends StatefulWidget {
  final UserType userType; // Add this parameter

  const VerifyemailPage({Key? key, required this.userType}) : super(key: key);

  @override
  State<VerifyemailPage> createState() => _VerifyemailPageState();
}

class _VerifyemailPageState extends State<VerifyemailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Initially set email verification status
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      // Move the initial email sending to after the build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        sendVerificationEmail();
      });

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      String errorMessage =
          'Failed to send verification email. Please try again.'; // Default English
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'too-many-requests':
            errorMessage =
                'Try again later. You have made too many requests too quickly.';
            break;
          default:
            print('Verification Email Error: ${e.code}');
            break;
        }
      } else {
        print('Non-FirebaseAuth Error sending verification email: $e');
      }
      // Access ScaffoldMessenger in the build method
      if (mounted) {
        // Check if the widget is still in the tree
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
      // Navigate based on the passed userType
      if (widget.userType == UserType.customer) {
        constants.globalFunctions.nextScreenReplace(
          context,
          const CustomerHomePage(),
        );
      } else if (widget.userType == UserType.seller) {
              constants.globalFunctions.showToast(
                  message: 'Email Verfied Now Wait \n For Admin Approval For Seller Acount',
                  toastType: ToastType.success);
           constants.authServices.signOut(context: context);

      } else if (widget.userType == UserType.admin) {
        constants.globalFunctions.nextScreenReplace(
          context,
          const AdminHomePage(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const Center(
          child: Text(
              'Email Verified! You can now login.')) // You might want a different UI here
      : Scaffold(
        backgroundColor: Colors.grey.shade400,
        appBar: AppBar(
          title: const Text("Verify Email"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.accent,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
     body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: AppColors.accent,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'A verification email has been sent to your email address.',
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please check your inbox and click the link to verify your email.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: canResendEmail ? sendVerificationEmail : null,
                    icon: const Icon(Icons.email, size: 24),
                    label: const Text(
                      'Resend Email',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      
          ),
        );
}
