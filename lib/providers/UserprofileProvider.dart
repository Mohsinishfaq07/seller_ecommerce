import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/customer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Separate provider for FirebaseAuth instance
final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class CustomerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomerRepository();

  // Function to update CustomerModel data in Firestore for the currently logged-in user
  Future<void> updateCurrentUserCustomerData(
      Map<String, dynamic> newData) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .update(newData);
      } catch (e) {
        print("Error updating current user's customer data: $e");
        rethrow;
      }
    } else {
      print("No user is currently logged in to update data.");
      throw Exception("No user logged in.");
    }
  }

  // Function to fetch CustomerModel by userId
  Future<CustomerModel?> getCustomerData(String userId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(userId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return CustomerModel.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching customer data for user ID $userId: $e");
      return null;
    }
  }

  // Function to fetch the CustomerModel of the *currently logged-in user*
  Future<CustomerModel?> getCurrentUserCustomerData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      return getCustomerData(currentUser.uid);
    }
    return null;
  }
}

// Riverpod Provider for the CustomerRepository instance
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

// Riverpod Provider to fetch the CustomerModel of the currently logged-in user
final currentCustomerProvider = FutureProvider<CustomerModel?>((ref) async {
  final customerRepository = ref.watch(customerRepositoryProvider);
  return customerRepository.getCurrentUserCustomerData();
});

// Riverpod Provider for managing the state of the currently logged-in customer for editing
final editingCustomerProvider = StateProvider<CustomerModel?>((ref) {
  return ref.watch(currentCustomerProvider).value?.copyWith();
});
