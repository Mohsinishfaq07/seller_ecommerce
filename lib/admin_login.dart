import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'firestore.dart'; // Import FirestoreService

class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  String _errorMessage = '';
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Reset the error message
      });

      try {
        // Sign in the user with Firebase Auth

        // Fetch userType from Firestore
        // String userType =
        //     await _firestoreService.getUserType(userCredential.user!.uid);
        // print("Fetched User Type: $userType"); // Debugging

        // // Navigate based on userType
        // switch (userType) {
        //   case 'admin':
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => AdminHomePage()),
        //     );
        //     break;
        //   case 'customer':
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => CustomerHomePage()),
        //     );
        //     break;
        //   case 'seller':
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => SellerHomePage()),
        //     );
        //     break;
        //   default:
        //     Fluttertoast.showToast(
        //       msg: "Unauthorized access. Contact support.",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.BOTTOM,
        //       backgroundColor: Colors.red,
        //       textColor: Colors.white,
        //     );
        // }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? "Login failed.";
        });
      } catch (e) {
        setState(() {
          _errorMessage = "An error occurred.";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo or Icon
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('images/logo.jpeg'),
                  ),
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
                  TextFormField(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onChanged: (value) => _email = value.trim(),
                  ),
                  const SizedBox(height: 20),
                  // Password field
                  TextFormField(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onChanged: (value) => _password = value.trim(),
                  ),
                  const SizedBox(height: 30),
                  // Login button
                  ElevatedButton(
                    onPressed: _login, // Call _login method here
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.teal,
                          )
                        : const Text(
                            'Log In',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                  const SizedBox(height: 20),
                  // Error message display
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
