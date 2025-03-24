import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './welcome_screen.dart';
import 'main.dart'; // Welcome or login screen

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance
//           .authStateChanges(), // Listen to auth state changes
//       builder: (context, snapshot) {
//         // Check the connection state of the stream
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show a loading indicator while checking auth state
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           // Handle errors gracefully
//           return const Center(
//             child: Text(
//               'Something went wrong. Please try again later.',
//               style: TextStyle(color: Colors.red, fontSize: 16),
//             ),
//           );
//         }

//         if (snapshot.hasData) {
//           // If a user is logged in, navigate to the home screen
//           return const HomePage();
//         } else {
//           // If no user is logged in, navigate to the welcome/login screen
//           return const WelcomeHomeScreen();
//         }
//       },
//     );
//   }
// }
