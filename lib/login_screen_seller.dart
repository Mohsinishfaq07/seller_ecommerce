// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/customer_home.dart';
// import 'package:flutter_application_1/seller_home.dart';
// import 'package:flutter_application_1/signup_screen.dart';
// import 'package:flutter_application_1/welcome_screen.dart';

// import 'firestore.dart'; // Import FirestoreService

// class LoginSeller extends StatefulWidget {
//   const LoginSeller({Key? key}) : super(key: key);

//   @override
//   State<LoginSeller> createState() => _LoginSellerState();
// }

// class _LoginSellerState extends State<LoginSeller> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirestoreService _firestoreService = FirestoreService();

//   String _email = '';
//   String _password = '';
//   String _errorMessage = '';
//   bool _isLoading = false;

//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = ''; // Reset the error message
//       });

//       try {
//         // Sign in the user with Firebase Auth
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: _email,
//           password: _password,
//         );

//         // Fetch the user role from Firestore
//         String userType =
//         await _firestoreService.getUserType(userCredential.user!.uid);

//         // Navigate to the appropriate home screen based on the user role
//         if (userType == 'seller') {
//           Navigator.pushReplacementNamed(context, '/seller_home');
//         } else if (userType == 'customer') {
//           Navigator.pushReplacementNamed(context, '/customer_home');
//         } else if (userType == 'admin') {
//           Navigator.pushReplacementNamed(context, '/admin_home');
//         } else {
//           setState(() {
//             _errorMessage = "Unknown user type. Please contact support.";
//           });
//         }
//       } on FirebaseAuthException catch (e) {
//         setState(() {
//           _errorMessage = e.message ?? "Login failed. Please try again.";
//         });
//       } catch (e) {
//         setState(() {
//           _errorMessage = "An error occurred. Please try again.";
//         });
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.teal, Colors.lightGreenAccent],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo or Icon
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage('images/logo.jpeg'),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Welcome Back!',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Log in to continue',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   // Email field
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Email',
//                       labelStyle: const TextStyle(color: Colors.black),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.8),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) => _email = value.trim(),
//                   ),
//                   const SizedBox(height: 20),
//                   // Password field
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       labelStyle: const TextStyle(color: Colors.black),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.8),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) => _password = value.trim(),
//                   ),
//                   const SizedBox(height: 30),
//                   // Login button
//                   ElevatedButton(
//                     onPressed:(){
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=> SellerHomePage()));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 15),
//                       backgroundColor: Colors.white,
//                       foregroundColor: Colors.teal,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                     ),
//                     child: _isLoading
//                         ? const CircularProgressIndicator(
//                       color: Colors.teal,
//                     )
//                         : const Text(
//                       'Log In',
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Error message display
//                   if (_errorMessage.isNotEmpty)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10),
//                       child: Text(
//                         _errorMessage,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
