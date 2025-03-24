// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   Future<String> getUserType(String uid) async {
//     try {
//       DocumentSnapshot userDoc = await _db.collection("users").doc(uid).get();
//       if (userDoc.exists) {
//         return userDoc['userType'] ??
//             'unknown'; // Ensure 'userType' is the correct field name
//       } else {
//         return 'unknown'; // Handle missing documents
//       }
//     } catch (e) {
//       print("Error fetching user type: $e");
//       return 'unknown'; // Handle errors
//     }
//   }

//   Future<void> addUser(String userId, Map<String, dynamic> userData) async {
//     await _db.collection("users").doc(userId).set(userData);
//   }

//   Future<void> getAllUsers() async {
//     await _db.collection("users").get().then((event) {
//       for (var doc in event.docs) {
//         print("${doc.id} => ${doc.data()}");
//       }
//     });
//   }
// }
