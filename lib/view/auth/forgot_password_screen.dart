import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/constants/app_colors.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/providers/forgot_password_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/enums/global_enums.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  Future<void> _handleResetPassword(BuildContext context, WidgetRef ref) async {
    final forgotPasswordState = ref.read(forgotPasswordProvider);
    final email = forgotPasswordState.emailController.text.trim();

    if (email.isEmpty) {
      constants.globalFunctions.showToast(
        message: 'Please enter your email',
        toastType: ToastType.error,
      );
      return;
    }

    forgotPasswordState.setLoading(true);

    try {
      await constants.authServices.forgotPassword(email: email);
      if (context.mounted) {
        forgotPasswordState.setEmailSent(true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please check your email inbox and spam folder for the reset link',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('Reset password error: $e');
    } finally {
      if (context.mounted) {
        forgotPasswordState.setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final isLoading = forgotPasswordState.isLoading;
    final emailSent = forgotPasswordState.emailSent;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Icon
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_reset_outlined,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Reset Password',
                    style: AppStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  if (!emailSent) ...[
                    // Description
                    const Text(
                      'Enter your email address and we\'ll send you a link to reset your password',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Email Input Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppStyles.formContainerDecoration,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: forgotPasswordState.emailController,
                            label: 'Email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _handleResetPassword(context, ref),
                        style: AppStyles.primaryButtonStyle,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Reset Password',
                                style: AppStyles.buttonTextStyle,
                              ),
                      ),
                    ),
                  ] else ...[
                    // Success Message
                    const Text(
                      'Password reset link has been sent to your email. Please check your inbox and follow the instructions.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: AppStyles.primaryButtonStyle,
                        child: const Text(
                          'Back to Login',
                          style: AppStyles.buttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
