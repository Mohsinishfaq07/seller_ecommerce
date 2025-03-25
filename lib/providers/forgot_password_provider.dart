import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordNotifier extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool emailSent = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setEmailSent(bool value) {
    emailSent = value;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}

final forgotPasswordProvider = ChangeNotifierProvider.autoDispose((ref) {
  return ForgotPasswordNotifier();
});
