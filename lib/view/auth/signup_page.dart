import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/services/auth/SignupService.dart';
import 'package:flutter_application_1/view/auth/Verifyemail.dart';
import 'package:flutter_application_1/widgets/AddressField.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerSignUpPage extends ConsumerStatefulWidget {
  const CustomerSignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerSignUpPage> createState() => _CustomerSignUpPageState();
}

class _CustomerSignUpPageState extends ConsumerState<CustomerSignUpPage> {
  final _formKey = GlobalKey<FormState>(); // Add a GlobalKey for the Form

  Future<void> _handleSignUp(
      BuildContext context, WidgetRef ref, UserType userType) async {
    if (_formKey.currentState!.validate()) {
      final auth = ref.read(authProvider);

      if (userType == UserType.seller &&
          (auth.shopNameController.text.isEmpty ||
              auth.shopTypeController.text.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all seller details')),
        );
        return;
      }

      auth.setLoading(true);

      try {
        await constants.authServices.createAccount(
          address: auth.addresscontroller.text,
          email: auth.emailController.text,
          password: auth.passwordController.text,
          name: auth.userNameController.text,
          context: context,
          userType: userType,
          ref: ref,
          confirmPassword: auth.confirmPasswordController.text,
          number: auth.numberController.text,
          shopName:
              userType == UserType.seller ? auth.shopNameController.text : null,
          shopType:
              userType == UserType.seller ? auth.shopTypeController.text : null,
        );
        await UserTypePrefs.storeUserType(userType);
        constants.globalFunctions.nextScreenReplace(
          context,
          VerifyemailPage(userType: userType),
        );
      } catch (e) {
        debugPrint('Signup error handled in _handleSignUp: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: ${e.toString()}')),
        );
      } finally {
        auth.setLoading(false);
      }
    }
  }

  Widget _buildAccountTypeDropdown(WidgetRef ref, UserType currentUserType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF00897B),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<UserType>(
            value: currentUserType,
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.person_pin_outlined,
                size: 20,
                color: Color(0xFF00897B),
              ),
            ),
            dropdownColor: Colors.white,
            items: [UserType.customer, UserType.seller].map((UserType type) {
              return DropdownMenuItem<UserType>(
                value: type,
                child: Text(
                  type == UserType.customer ? 'Customer' : 'Seller',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              );
            }).toList(),
            onChanged: (UserType? newValue) {
              if (newValue != null) {
                ref.read(userTypeProvider.notifier).state = newValue;
                ref.read(authProvider).setUserType(newValue);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShopDetails(WidgetRef ref, UserType userType) {
    if (userType == UserType.seller) {
      final auth = ref.watch(authProvider);
      final selectedShopType = ref.watch(shopTypeStateProvider);
      return Column(
        children: [
          CustomTextField(
            controller: auth.shopNameController,
            label: 'Shop Name',
            prefixIcon: Icons.store_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your shop name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shop Type',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF00897B),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<ShopType>(
                  value: selectedShopType,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.store_outlined,
                      size: 20,
                      color: Color(0xFF00897B),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  items: ShopType.values.map((ShopType type) {
                    return DropdownMenuItem<ShopType>(
                      value: type,
                      child: Text(
                        type.displayName,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    );
                  }).toList(),
                  onChanged: (ShopType? newValue) {
                    if (newValue != null) {
                      ref.read(shopTypeStateProvider.notifier).state = newValue;
                      auth.shopTypeController.text = newValue.displayName;
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your shop type';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final userType = ref.watch(userTypeProvider);
    final auth = ref.watch(authProvider);
    final isLoading = auth.isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00897B), Color(0xFF4DB6AC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form( // Wrap the Column with a Form widget
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 15),
                            const Icon(
                              Icons.store_rounded,
                              size: 50,
                              color: Color(0xFF00897B),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00897B),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: auth.userNameController,
                              label: 'Full Name',
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildAccountTypeDropdown(ref, userType),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: auth.emailController,
                              label: 'Email',
                              prefixIcon: Icons.email_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: auth.numberController,
                              label: 'Phone Number',
                              prefixIcon: Icons.phone_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Please enter only numbers';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                         CustomAddressField(controller: auth.addresscontroller, label: "Address", prefixIcon: Icons.abc),
                            _buildShopDetails(ref, userType),
                               const SizedBox(height: 25),
                            CustomTextField(
                              hidepass: () {
                                ref.read(showPasswordProvider.notifier).state =
                                    !ref.read(showPasswordProvider);
                              },
                              sufficon: ref.watch(showPasswordProvider)
                                  ? Icons.remove_red_eye_sharp
                                  : Icons.remove_red_eye_outlined,
                              isPassword: !ref.watch(showPasswordProvider),
                              controller: auth.passwordController,
                              label: 'Password',
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              hidepass: () {
                                ref.read(showPasswordProvider.notifier).state =
                                    !ref.read(showPasswordProvider);
                              },
                              sufficon: ref.watch(showPasswordProvider)
                                  ? Icons.remove_red_eye_sharp
                                  : Icons.remove_red_eye_outlined,
                              isPassword: !ref.watch(showPasswordProvider),
                              controller: auth.confirmPasswordController,
                              label: 'Confirm Password',
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != auth.passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () =>
                                        _handleSignUp(context, ref, userType),
                                style: AppStyles.primaryButtonStyle,
                                child: isLoading
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.grey, fontSize: 15),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30)),
                                  child: const Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: Color(0xFF00897B),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}