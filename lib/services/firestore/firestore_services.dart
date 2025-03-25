import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
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
}
