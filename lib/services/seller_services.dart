import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/seller_model.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/seller_home.dart';



class SellerServices {
  Future<void> createSellerAccount({
    required String email,
    required String password,
    required String name,
    required String number,
    required String confirmPassword,
    required String shopName,
    required String shopType,
    required BuildContext context,
  }) async {
    try {
      // Create seller model
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final seller = SellerModel(
        userId: credential.user!.uid,
        name: name,
        email: email,
        password: password,
        number: number,
        shopName: shopName,
        shopType: shopType,
      );

      if (!seller.isValidSeller()) {
        throw Exception('Invalid seller data');
      }

      // Store seller data
      final dataStored = await firestoreService.storeUserData(user: seller);

      if (dataStored) {
        globalFunctions.showToast(
          message: 'Seller account created successfully',
          toastType: ToastType.success,
        );

        // Navigate to seller home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerHomePage()),
        );
      }
    } catch (e) {
      globalFunctions.showToast(
        message: 'Error creating seller account: ${e.toString()}',
        toastType: ToastType.error,
      );
    }
  }

  // Add other seller-specific methods here
}
