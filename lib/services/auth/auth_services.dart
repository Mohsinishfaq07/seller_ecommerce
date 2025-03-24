import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/general_models/user_model.dart';
import 'package:flutter_application_1/view/customer/buyer_home/customer_home.dart';
import 'package:flutter_application_1/welcome_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthServices {
  createAccount({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String number,
    required BuildContext context,
    required UserType userType,
    required WidgetRef ref,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty || number.isEmpty) {
      globalFunctions.showToast(
          message: 'Please enter all details', toastType: ToastType.error);
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
        bool dataStored = await firestoreService.storeUserData(
          user: UserDetail(
            name: name,
            email: email,
            password: password,
            userId: credential.user!.uid,
            userType: userType,
            number: number,
          ),
        );
        if (dataStored) {
          globalFunctions.showToast(
              message: 'Account created successfully',
              toastType: ToastType.info);
          globalFunctions.showToast(
              message: 'Account created successfully',
              toastType: ToastType.info);
          if (userType == UserType.customer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CustomerHomePage()),
            );
          } else if (userType == UserType.seller) {
          } else if (userType == UserType.admin) {}
          await credential.user!.delete();

          globalFunctions.showToast(
              message: 'Failed to create account\n try again in 5 minutes',
              toastType: ToastType.error);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          globalFunctions.showToast(
              message: 'The password provided is too weak.',
              toastType: ToastType.error);
          debugPrint('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          globalFunctions.showToast(
              message: 'The account already exists for that email.',
              toastType: ToastType.error);
          debugPrint('The account already exists for that email.');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  login(
      {required String email,
      required String password,
      required BuildContext context,
      required WidgetRef widgetRef}) async {
    if (email.isEmpty || password.isEmpty) {
      globalFunctions.showToast(
          message: 'Please enter email and password',
          toastType: ToastType.error);
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
    } else {
      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CustomerHomePage()),
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        globalFunctions.showToast(
            message: 'Credentials are incorrect', toastType: ToastType.error);
        if (e.code == 'user-not-found') {
          globalFunctions.showToast(
              message: 'user not found', toastType: ToastType.error);
          debugPrint('The user does not exist.');
        } else if (e.code == 'wrong-password') {
          globalFunctions.showToast(
              message: 'Credentials are incorrect', toastType: ToastType.error);
          debugPrint('The password is invalid for that user.');
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  signOut({
    required BuildContext context,
  }) async {
    try {
      await FirebaseAuth.instance.signOut().then((val) {
        globalFunctions.nextScreen(context, const WelcomeHomeScreen());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  forgotPassword({
    required String email,
  }) async {
    if (email.isEmpty) {
      globalFunctions.showToast(
          message: 'Please enter email', toastType: ToastType.error);
      return;
    } else if (!email.contains('@')) {
      globalFunctions.showToast(
          message: 'Please enter valid email', toastType: ToastType.error);
      return;
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        globalFunctions.showToast(
            message: 'Password reset link has been sent to your email',
            toastType: ToastType.success);
      } catch (e) {
        globalFunctions.showToast(
            message: 'Something went wrong', toastType: ToastType.error);
        debugPrint(e.toString());
      }
    }
  }
}
