import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String cartKey = 'cartItems';
  static const String itemCountKey = 'cartItemCount';
  static final StreamController<int> _totalItemsController =
      StreamController<int>.broadcast();

  static Stream<int> get totalItemsStream => _totalItemsController.stream;

  // Stream to fetch total price (keeping the periodic update)
  static Stream<double> get totalStream async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield await calculateTotal();
    }
  }

  // Helper function to calculate and store the total item count in SharedPreferences
  static Future<void> _updateTotalItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];
    int totalItems = 0;
    for (var item in cartList) {
      Map<String, dynamic> product = jsonDecode(item);
      totalItems += int.parse(product['quantity']);
    }
    await prefs.setInt(itemCountKey, totalItems);
    _totalItemsController.sink
        .add(totalItems); // Still emit to the existing stream
  }

  // Function to get the current total item count from SharedPreferences
  static Future<int> _getCurrentItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(itemCountKey) ?? 0;
  }

  // Add product to cart
  static Future<void> addProduct({required CardModel product}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];

    int index = cartList.indexWhere((item) {
      Map<String, dynamic> existingItem = jsonDecode(item);
      return existingItem['productId'] == product.productId;
    });

    if (index != -1) {
      Map<String, dynamic> existingItem = jsonDecode(cartList[index]);
      int newQuantity =
          int.parse(existingItem['quantity']) + int.parse(product.quantity);
      existingItem['quantity'] = newQuantity.toString();
      cartList[index] = jsonEncode(existingItem);
    } else {
      cartList.add(jsonEncode(product.toMap()));
    }

    await prefs.setStringList(cartKey, cartList);
    debugPrint(cartList.length.toString());
    globalFunctions.showToast(
        message: 'Added to cart', toastType: ToastType.success);
    _updateTotalItemCount(); // Update and emit count
  }

// Remove product from cart
  static Future<void> removeProduct({required String productId}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];
    cartList.removeWhere((item) => jsonDecode(item)['productId'] == productId);
    await prefs.setStringList(cartKey, cartList);
    _updateTotalItemCount(); // Update and emit count
  }

// Update product quantity
  static Future<void> updateProductQuantity({
    required String productId,
    required int quantityChange,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];

    int index = cartList.indexWhere((item) {
      Map<String, dynamic> existingItem = jsonDecode(item);
      return existingItem['productId'] == productId;
    });

    if (index != -1) {
      Map<String, dynamic> existingItem = jsonDecode(cartList[index]);
      int currentQuantity = int.parse(existingItem['quantity']);
      int newQuantity = currentQuantity + quantityChange;

      if (newQuantity <= 0) {
        cartList.removeAt(index);
      } else {
        existingItem['quantity'] = newQuantity.toString();
        cartList[index] = jsonEncode(existingItem);
      }

      await prefs.setStringList(cartKey, cartList);
      _updateTotalItemCount(); // Update and emit count
    } else {
      throw Exception('Product with ID $productId not found in cart');
    }
  }

// Get cart items with continuous yielding every 200 milliseconds (no changes needed)
  static Stream<List<CardModel>> loadProductsStream() async* {
    while (true) {
      final prefs = await SharedPreferences.getInstance();
      List<String> cartList = prefs.getStringList(cartKey) ?? [];

      List<CardModel> products = cartList.map((item) {
        Map<String, dynamic> decodedItem = jsonDecode(item);
        return CardModel.fromMap(decodedItem);
      }).toList();

      yield products;
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  static Future<List<CardModel>> loadProductsFromCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];
    return cartList.map((item) {
      Map<String, dynamic> decodedItem = jsonDecode(item);
      return CardModel.fromMap(decodedItem);
    }).toList();
  }

  // Calculate total price (no changes needed)
  static Future<double> calculateTotal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];
    double total = 0.0;
    for (var item in cartList) {
      Map<String, dynamic> product = jsonDecode(item);
      total += int.parse(product['quantity']) *
          double.parse(product['productPrice']);
    }
    return total;
  }

  // Clear cart
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
    await prefs.setInt(itemCountKey, 0); // Reset count in SharedPreferences
    _totalItemsController.sink.add(0); // Emit 0 when cart is cleared
  }

  // No need for getTotalItemsInCart anymore if relying on the stream
}
