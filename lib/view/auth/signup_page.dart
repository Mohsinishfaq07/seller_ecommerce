import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/app_styles.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/providers/auth_provider.dart';
import 'package:flutter_application_1/view/auth/Verifyemail.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

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
final userTypeProvider = StateProvider<UserType>(
    (ref) => UserType.customer); // Define userTypeProvider

class UserTypePrefs {
  static const String _userTypeKey = 'userType';

  /// Stores the [UserType] in SharedPreferences.
  static Future<bool> storeUserType(UserType userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userTypeKey, userType.name);
  }

  /// Fetches the stored [UserType] from SharedPreferences.
  /// Returns null if no user type is stored.
  static Future<UserType?> fetchUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userTypeValue = prefs.getString(_userTypeKey);
    if (userTypeValue != null) {
      return UserType.values.firstWhere((type) => type.name == userTypeValue);
    }
    return null;
  }

  /// Clears the stored user type from SharedPreferences.
  static Future<bool> clearUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userTypeKey);
  }
}

class CustomerSignUpPage extends ConsumerWidget {
  const CustomerSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final userType = ref.watch(userTypeProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Gradient
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
                  constraints:
                      const BoxConstraints(maxWidth: 350), // Reduced max width
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 15), // Reduced top spacing
                          const Icon(
                            Icons.store_rounded,
                            size: 50, // Reduced icon size
                            color: Color(0xFF00897B),
                          ),
                          const SizedBox(height: 12), // Reduced spacing
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 22, // Reduced title size
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00897B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20), // Reduced spacing
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
                          const SizedBox(height: 12), // Reduced spacing
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final userType = ref.watch(userTypeProvider);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Account Type',
                                    style: TextStyle(
                                      fontSize: 14, // Reduced label size
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF00897B),
                                    ),
                                  ),
                                  const SizedBox(height: 6), // Reduced spacing
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
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
                                      value: userType,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6), // Reduced padding
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                          Icons.person_pin_outlined,
                                          size: 20, // Reduced icon size
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
                                              fontSize: 14, // Reduced text size
                                              color: Colors.black87,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (UserType? newValue) {
                                        if (newValue != null) {
                                          ref
                                              .read(userTypeProvider.notifier)
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
                          const SizedBox(height: 12), // Reduced spacing
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final auth = ref.watch(authProvider);
                              return CustomTextField(
                                controller: auth.emailController,
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                              );
                            },
                          ),
                          const SizedBox(height: 12), // Reduced spacing
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final auth = ref.watch(authProvider);
                              return CustomTextField(
                                controller: auth.numberController,
                                label: 'Phone Number',
                                prefixIcon: Icons.phone_outlined,
                              );
                            },
                          ),
                          const SizedBox(height: 12), // Reduced spacing
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final userType = ref.watch(userTypeProvider);
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
                                    const SizedBox(
                                        height: 12), // Reduced spacing
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Shop Type',
                                          style: TextStyle(
                                            fontSize: 14, // Reduced label size
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF00897B),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: 6), // Reduced spacing
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
                                              DropdownButtonFormField<ShopType>(
                                            value: selectedShopType,
                                            decoration: const InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical:
                                                          6), // Reduced padding
                                              border: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.store_outlined,
                                                size: 20, // Reduced icon size
                                                color: Color(0xFF00897B),
                                              ),
                                            ),
                                            dropdownColor: Colors.white,
                                            items: ShopType.values
                                                .map((ShopType type) {
                                              return DropdownMenuItem<ShopType>(
                                                value: type,
                                                child: Text(
                                                  type.displayName,
                                                  style: const TextStyle(
                                                    fontSize:
                                                        14, // Reduced text size
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (ShopType? newValue) {
                                              if (newValue != null) {
                                                ref
                                                    .read(shopTypeStateProvider
                                                        .notifier)
                                                    .state = newValue;
                                                auth.shopTypeController.text =
                                                    newValue.displayName;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 12), // Reduced spacing
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 12), // Reduced spacing
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final auth = ref.watch(authProvider);
                              return CustomTextField(
                                controller: auth.passwordController,
                                label: 'Password',
                                prefixIcon: Icons.lock_outline,
                              );
                            },
                          ),
                          const SizedBox(height: 12), // Reduced spacing
                          Consumer(
                            builder: (_, WidgetRef ref, __) {
                              final auth = ref.watch(authProvider);
                              return CustomTextField(
                                controller: auth.confirmPasswordController,
                                label: 'Confirm Password',
                                prefixIcon: Icons.lock_outline,
                              );
                            },
                          ),
                          const SizedBox(height: 20), // Reduced spacing
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
                              );
                            },
                          ),
                          const SizedBox(height: 16), // Reduced spacing
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30)),
                                child: const Text(
                                  "Log in", // Improved text
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
                          const SizedBox(height: 15), // Reduced bottom spacing
                        ],
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
      // Store the user type after successful account creation
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
