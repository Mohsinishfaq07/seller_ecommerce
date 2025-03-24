import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthProvider {
  final userNameController = StateProvider(
    (ref) => TextEditingController(),
  );
  final passwordController = StateProvider(
    (ref) => TextEditingController(),
  );
  final confirmPasswordController = StateProvider(
    (ref) => TextEditingController(),
  );
  final emailController = StateProvider(
    (ref) => TextEditingController(),
  );

  final numberController = StateProvider(
    (ref) => TextEditingController(),
  );
  final isLoading = StateProvider((ref) => false);
}
