import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/general_models/user_model.dart';

class FirestoreService {
  Future<bool> storeUserData({required UserDetail user}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.userId)
          .set(user.toJson());
      return true;
    } catch (e) {
      globalFunctions.showLog(message: "Error storing user data: $e");
      globalFunctions.showToast(
          message: 'Failed to store user data:${e.toString()}',
          toastType: ToastType.error);
      return false;
    }
  }
}
