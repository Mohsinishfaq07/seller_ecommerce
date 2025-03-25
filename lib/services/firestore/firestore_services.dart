import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool> storeUserData({required dynamic user}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .set(user.toMap());
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  // delete account
  deleteAccount({
    required String docId,
  }) async {
    try {
      await _firestore.collection('users').doc(docId).delete();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      globalFunctions.showToast(
          message: 'User deleted successfully', toastType: ToastType.success);
    } catch (e) {
      globalFunctions.showLog(message: 'error: ${e.toString()}');
    }
  }
}
