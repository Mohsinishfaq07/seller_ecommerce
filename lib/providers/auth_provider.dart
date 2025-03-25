import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/global_enums.dart';

// Define the provider
final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

final userTypeProvider = StateProvider<UserType>((ref) => UserType.customer);

class AuthProvider extends ChangeNotifier {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final numberController = TextEditingController();
  final shopNameController = TextEditingController();
  final shopTypeController = TextEditingController();

  // State variables
  bool _isLoading = false;
  UserType _userType = UserType.customer;

  // Getters
  bool get isLoading => _isLoading;
  UserType get userType => _userType;

  // Methods to update state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUserType(UserType type) {
    _userType = type;
    notifyListeners();
  }

  // Dispose controllers when not needed
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    confirmPasswordController.dispose();
    numberController.dispose();
    shopNameController.dispose();
    shopTypeController.dispose();
    super.dispose();
  }
}
