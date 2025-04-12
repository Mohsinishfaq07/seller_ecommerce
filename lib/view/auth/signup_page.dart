import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/view/auth/login_page.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_application_1/constants/app_styles.dart';

enum ShopType {
  online,
  physical,
  both;

  String get displayName {
    switch (this) {
      case ShopType.online:
        return 'Online Shop';
      case ShopType.physical:
        return 'Physical Shop';
      case ShopType.both:
        return 'Both (Online & Physical)';
    }
  }
}

final shopTypeStateProvider = StateProvider<ShopType>((ref) => ShopType.online);

class CustomerSignUpPage extends StatelessWidget {
  const CustomerSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Static header section
              const SizedBox(height: 20),
              const Icon(
                Icons.store_rounded,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Scrollable form section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Scrollable form fields
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Name Field
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final auth = ref.watch(authProvider);
                                    return CustomTextField(
                                      controller: auth.userNameController,
                                      label: 'Full Name',
                                      prefixIcon: Icons.person_outline,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),

                                // User Type Dropdown
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final userType =
                                        ref.watch(userTypeProvider);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Account Type',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF00897B),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                spreadRadius: 1,
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child:
                                              DropdownButtonFormField<UserType>(
                                            value: userType,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.person_pin_outlined,
                                                color: Color(0xFF00897B),
                                              ),
                                            ),
                                            dropdownColor: Colors.white,
                                            items: [
                                              UserType.customer,
                                              UserType.seller
                                            ].map((UserType type) {
                                              return DropdownMenuItem<UserType>(
                                                value: type,
                                                child: Text(
                                                  type == UserType.customer
                                                      ? 'Customer'
                                                      : 'Seller',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (UserType? newValue) {
                                              if (newValue != null) {
                                                ref
                                                    .read(userTypeProvider
                                                        .notifier)
                                                    .state = newValue;
                                                ref
                                                    .read(authProvider)
                                                    .setUserType(newValue);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Email Field
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final auth = ref.watch(authProvider);
                                    return CustomTextField(
                                      controller: auth.emailController,
                                      label: 'Email',
                                      prefixIcon: Icons.email_outlined,
                                      keyboardType: TextInputType.emailAddress,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Phone Number Field
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final auth = ref.watch(authProvider);
                                    return CustomTextField(
                                      controller: auth.numberController,
                                      label: 'Phone Number',
                                      prefixIcon: Icons.phone_outlined,
                                      keyboardType: TextInputType.phone,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Seller Specific Fields
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final userType =
                                        ref.watch(userTypeProvider);
                                    final auth = ref.watch(authProvider);
                                    final selectedShopType =
                                        ref.watch(shopTypeStateProvider);

                                    if (userType == UserType.seller) {
                                      return Column(
                                        children: [
                                          CustomTextField(
                                            controller: auth.shopNameController,
                                            label: 'Shop Name',
                                            prefixIcon: Icons.store_outlined,
                                          ),
                                          const SizedBox(height: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Shop Type',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF00897B),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.1),
                                                      spreadRadius: 1,
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: DropdownButtonFormField<
                                                    ShopType>(
                                                  value: selectedShopType,
                                                  decoration:
                                                      const InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 8),
                                                    border: InputBorder.none,
                                                    prefixIcon: Icon(
                                                      Icons.store_outlined,
                                                      color: Color(0xFF00897B),
                                                    ),
                                                  ),
                                                  dropdownColor: Colors.white,
                                                  items: ShopType.values
                                                      .map((ShopType type) {
                                                    return DropdownMenuItem<
                                                        ShopType>(
                                                      value: type,
                                                      child: Text(
                                                        type.displayName,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (ShopType? newValue) {
                                                    if (newValue != null) {
                                                      ref
                                                          .read(
                                                              shopTypeStateProvider
                                                                  .notifier)
                                                          .state = newValue;
                                                      auth.shopTypeController
                                                              .text =
                                                          newValue.displayName;
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),

                                // Password Field
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final auth = ref.watch(authProvider);
                                    return CustomTextField(
                                      controller: auth.passwordController,
                                      label: 'Password',
                                      prefixIcon: Icons.lock_outline,
                                      isPassword: true,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Confirm Password Field
                                Consumer(
                                  builder: (_, WidgetRef ref, __) {
                                    final auth = ref.watch(authProvider);
                                    return CustomTextField(
                                      controller:
                                          auth.confirmPasswordController,
                                      label: 'Confirm Password',
                                      prefixIcon: Icons.lock_outline,
                                      isPassword: true,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Static bottom section
                      const SizedBox(height: 30),
                      // Sign Up Button
                      Consumer(
                        builder: (_, WidgetRef ref, __) {
                          final auth = ref.watch(authProvider);
                          final userType = ref.watch(userTypeProvider);
                          final isLoading = auth.isLoading;

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => _handleSignUp(
                                      context, ref, auth, userType),
                              style: AppStyles.primaryButtonStyle,
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: AppStyles.buttonTextStyle,
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              constants.globalFunctions.nextScreen(
                                context,
                                const CustomerLoginScreen(),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context, WidgetRef ref, dynamic auth,
      UserType userType) async {
    final emailController = auth.emailController;
    final passwordController = auth.passwordController;
    final nameController = auth.userNameController;
    final confirmPassword = auth.confirmPasswordController;
    final numberController = auth.numberController;
    final shopNameController = auth.shopNameController;
    final shopTypeController = auth.shopTypeController;

    if (userType == UserType.seller &&
        (shopNameController.text.isEmpty || shopTypeController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all seller details')),
      );
      return;
    }

    // Set loading state
    auth.setLoading(true);

    try {
      await constants.authServices.createAccount(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        context: context,
        userType: userType,
        ref: ref,
        confirmPassword: confirmPassword.text,
        number: numberController.text,
        shopName: userType == UserType.seller ? shopNameController.text : null,
        shopType: userType == UserType.seller ? shopTypeController.text : null,
      );
    } catch (e) {
      // Error is already shown in auth service
      debugPrint('Signup error: $e');
    } finally {
      // Reset loading state
      auth.setLoading(false);
    }
  }
}
