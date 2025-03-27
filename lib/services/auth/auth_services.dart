import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/admin_home.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/seller_home.dart';
import 'package:flutter_application_1/view/admin/admin_home/admin_home.dart';
import 'package:flutter_application_1/view/customer/home_page/customer_home.dart';
import 'package:flutter_application_1/view/seller/seller_home/seller_home_page.dart';
import 'package:flutter_application_1/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/models/seller_model.dart';
import 'package:flutter_application_1/models/customer_model.dart';

class AuthServices {
  Future<void> createAccount({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String number,
    required BuildContext context,
    required UserType userType,
    required WidgetRef ref,
    String? shopName,
    String? shopType,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty || number.isEmpty) {
      globalFunctions.showToast(
          message: 'Please enter all details', toastType: ToastType.error);
      return;
    } else if (userType == UserType.seller &&
        (shopName?.isEmpty ?? true || shopType!.isEmpty ?? true)) {
      globalFunctions.showToast(
          message: 'Please enter shop details', toastType: ToastType.error);
      return;
    } else if (!email.contains('@')) {
      globalFunctions.showToast(
          message: 'Please enter valid email', toastType: ToastType.error);
      return;
    } else if (password.length < 6) {
      globalFunctions.showToast(
          message: 'Password should be minimum 6 characters',
          toastType: ToastType.error);
      return;
    } else if (name.length < 3) {
      globalFunctions.showToast(
          message: 'Name should be minimum 3 characters',
          toastType: ToastType.error);
    } else if (number.length < 11) {
      globalFunctions.showToast(
          message: 'Number should be minimum 11 characters',
          toastType: ToastType.error);
    } else if (password != confirmPassword) {
      globalFunctions.showToast(
          message: 'Passwords do not match', toastType: ToastType.error);
    } else {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint('account created');

        bool dataStored;
        if (userType == UserType.seller) {
          dataStored = await firestoreService.storeUserData(
            user: SellerModel(
              userId: credential.user!.uid,
              name: name,
              email: email,
              password: password,
              number: number,
              shopName: shopName!,
              shopType: shopType!,
              approved: false,
            ),
          );
        } else {
          dataStored = await firestoreService.storeUserData(
            user: CustomerModel(
              userId: credential.user!.uid,
              name: name,
              email: email,
              password: password,
              number: number,
            ),
          );
        }

        if (dataStored) {
          globalFunctions.showToast(
            message: 'Account created successfully',
            toastType: ToastType.success,
          );

          // Navigate based on user type
          if (userType == UserType.seller) {
            globalFunctions.showToast(
                message: 'Seller account created successfully',
                toastType: ToastType.success);
            globalFunctions.showToast(
                message: 'Account is under approval',
                toastType: ToastType.info);
            authServices.signOut(context: context);
          } else if (userType == UserType.customer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CustomerHomePage()),
            );
          }
        } else {
          throw Exception('Failed to store user data');
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          globalFunctions.showToast(
            message: 'The password provided is too weak.',
            toastType: ToastType.error,
          );
        } else if (e.code == 'email-already-in-use') {
          globalFunctions.showToast(
            message: 'The account already exists for that email.',
            toastType: ToastType.error,
          );
        }
        rethrow; // Rethrow to handle in UI
      } catch (e) {
        globalFunctions.showToast(
          message: 'Error creating account: ${e.toString()}',
          toastType: ToastType.error,
        );
        rethrow; // Rethrow to handle in UI
      }
    }
  }

  login({
    required String email,
    required String password,
    required BuildContext context,
    required WidgetRef widgetRef,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      globalFunctions.showToast(
        message: 'Please enter email and password',
        toastType: ToastType.error,
      );
      return;
    }

    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user data from Firestore
      final userData = await
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userData.exists) {
        final userType = UserType.values.firstWhere(
          (e) => e.toString() == userData['userType'],
          orElse: () => UserType.customer,
        );

        // Navigate based on user type
        if (userType == UserType.seller && userData['approved']) {
          globalFunctions.showToast(
            message: 'Login successful',
            toastType: ToastType.success,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SellerNewHomePage()),
          );
        } else if (userType == UserType.seller && !userData['approved']) {
          globalFunctions.showToast(
              message: 'Account not approved', toastType: ToastType.error);
          authServices.signOut(context: context);
        } else if (userData.exists && userType == UserType.admin) {
          globalFunctions.showToast(
            message: 'Admin Login successful',
            toastType: ToastType.success,
          );
          globalFunctions.nextScreen(context, const AdminHomePage());
        } else if (userType == UserType.customer) {
          globalFunctions.showToast(
            message: 'Login successful',
            toastType: ToastType.success,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CustomerHomePage()),
          );
        }
      } else {
        throw Exception('User data not found');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password';
      }
      globalFunctions.showToast(
        message: errorMessage,
        toastType: ToastType.error,
      );
    } catch (e) {
      globalFunctions.showToast(
        message: 'Error: ${e.toString()}',
        toastType: ToastType.error,
      );
    }
  }

  Future<void> signOut({
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signOut().then((val) {
        // globalFunctions.nextScreen(context, const WelcomeHomeScreen());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      // Validate email format
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.',
        );
      }

      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email.trim(),
      );

      globalFunctions.showToast(
        message: 'Password reset link has been sent to your email',
        toastType: ToastType.success,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later';
          break;
        default:
          errorMessage = 'Failed to send reset email: ${e.message}';
      }
      globalFunctions.showToast(
        message: errorMessage,
        toastType: ToastType.error,
      );
      throw Exception(errorMessage);
    } catch (e) {
      const errorMessage = 'An unexpected error occurred';
      globalFunctions.showToast(
        message: errorMessage,
        toastType: ToastType.error,
      );
      throw Exception(errorMessage);
    }
  }
}
