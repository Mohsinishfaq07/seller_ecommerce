import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Log in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
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
                const SizedBox(height: 30),
                // Login button
                Consumer(
                  builder: (_, WidgetRef ref, __) {
                    final isLoading = ref.watch(authProvider.isLoading);
                    final emailController =
                        ref.watch(authProvider.emailController);
                    final passwordController =
                        ref.read(authProvider.passwordController);

                    return ElevatedButton(
                      onPressed: () {
                        authServices.login(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                            widgetRef: ref);
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
                          ? const CircularProgressIndicator(
                              color: Colors.teal,
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(fontSize: 18),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
