import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/customer_model.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/view/customer/customer_bottom_navigationbar.dart';
import 'package:flutter_application_1/view/customer/home_page/customer_home.dart';

import '../enums/global_enums.dart';

class CustomerServices {
  Future<void> createCustomerAccount({
    required String email,
    required String password,
    required String name,
    required String number,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      // Create customer model
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final customer = CustomerModel(
        userId: credential.user!.uid,
        name: name,
        email: email,
        password: password,
        number: number,
      );

      if (!customer.isValidCustomer()) {
        throw Exception('Invalid customer data');
      }

      // Store customer data
      final dataStored = await firestoreService.storeUserData(user: customer);

      if (dataStored) {
        globalFunctions.showToast(
          message: 'Account created successfully',
          toastType: ToastType.success,
        );

        // Navigate to customer home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  CustomerBottomNavigationBar()),
        );
      }
    } catch (e) {
      globalFunctions.showToast(
        message: 'Error creating account: ${e.toString()}',
        toastType: ToastType.error,
      );
    }
  }

  // Add other customer-specific methods here
}
