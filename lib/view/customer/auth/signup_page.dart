import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/login_screen_customer.dart';
import 'package:flutter_application_1/view/customer/auth/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../firestore.dart'; // Import FirestoreService

class CustomerSignUpPage extends StatelessWidget {
  const CustomerSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0, // Removes the AppBar shadow
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.lightGreenAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo or Icon
                // const CircleAvatar(
                //   radius: 50,
                //   backgroundImage: AssetImage('images/logo.jpeg'),
                // ),
                const SizedBox(height: 20),

                // Name field
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final nameController =
                        ref.watch(authProvider.userNameController);
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onChanged: (value) {
                        nameController.text = value.trim();
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Email field
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final emailController =
                        ref.watch(authProvider.emailController);
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter your email';
                      //   }
                      //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      //     return 'Please enter a valid email';
                      //   }
                      //   return null;
                      // },
                      onChanged: (value) {
                        emailController.text = value.trim();
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final numberController =
                        ref.watch(authProvider.numberController);
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Number',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter your email';
                      //   }
                      //   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      //     return 'Please enter a valid email';
                      //   }
                      //   return null;
                      // },
                      onChanged: (value) {
                        numberController.text = value.trim();
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Password field
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final passwordController =
                        ref.watch(authProvider.passwordController);
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      obscureText: true,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter your password';
                      //   }
                      //   if (value.length < 6) {
                      //     return 'Password must be at least 6 characters';
                      //   }
                      //   return null;
                      // },
                      onChanged: (value) {
                        passwordController.text = value.trim();
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password field
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final confirmPasswordController =
                        ref.watch(authProvider.confirmPasswordController);
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      obscureText: true,
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please confirm your password';
                      //   }
                      //   if (value != _password) {
                      //     return 'Passwords do not match';
                      //   }
                      //   return null;
                      // },
                      onChanged: (value) {
                        confirmPasswordController.text = value.trim();
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),

                // User Type Dropdown

                // Signup button
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final isLoading = ref.watch(authProvider.isLoading);
                    final emailController =
                        ref.watch(authProvider.emailController);
                    final passwordController =
                        ref.read(authProvider.passwordController);
                    final nameController =
                        ref.read(authProvider.userNameController);
                    final confirmPassword =
                        ref.read(authProvider.confirmPasswordController);
                    final numberController =
                        ref.read(authProvider.numberController);
                    return ElevatedButton(
                      onPressed: () {
                        if (!isLoading) {
                          authServices.createAccount(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              context: context,
                              userType: UserType.customer,
                              ref: ref,
                              confirmPassword: confirmPassword.text,
                              number: numberController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.teal)
                          : const Text(
                              'Signup',
                              style: TextStyle(fontSize: 18),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Already have an account text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        globalFunctions.nextScreen(
                          context,
                          const CustomerLoginScreen(),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
