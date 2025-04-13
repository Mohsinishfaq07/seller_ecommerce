import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:flutter_application_1/models/product_sell_model.dart';
import 'package:flutter_application_1/services/cart_service/cart_service.dart';

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

  // upload product

  uploadProduct(
      {required ProductSellModel productSellModel,
      required String categoryName}) async {
    try {
      await _firestore
          .collection('products')
          .doc()
          .set(productSellModel.toMap());
      globalFunctions.showToast(
          message: 'Product uploaded successfully',
          toastType: ToastType.success);
    } catch (e) {
      globalFunctions.showLog(message: 'error: ${e.toString()}');
    }
  }

  // delete  product

  deleteProduct({
    required String productId,
  }) {
    try {
      FirebaseFirestore.instance.collection('products').doc(productId).delete();
      globalFunctions.showToast(
          message: 'Product deleted successfully',
          toastType: ToastType.success);
    } catch (e) {
      globalFunctions.showLog(message: 'error: ${e.toString()}');
    }
  }

  // update order status
  Future<void> updateOrderStatus(
      {required String orderId, required String status}) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': status});
    } catch (e) {
      globalFunctions.showLog(message: 'error: ${e.toString()}');
    }
  }

  // make order
  makeOrder({required List<CardModel> orders}) {
    try {
      for (var order in orders) {
        FirebaseFirestore.instance
            .collection('orders')
            .doc(order.orderId)
            .set(order.toMap());
      }
      globalFunctions.showToast(
          message: 'Order created successfully', toastType: ToastType.success);
      CartService.clearCart();
    } catch (e) {
      globalFunctions.showToast(
          message: 'Order creation failed', toastType: ToastType.error);
      globalFunctions.showLog(message: 'error: ${e.toString()}');
    }
  }
}
