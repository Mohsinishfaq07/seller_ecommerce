import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_application_1/models/cart_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String cartKey = 'cartItems';

  // Stream to fetch cart items

  // Stream to fetch total price
  static Stream<double> get totalStream async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield await calculateTotal();
    }
  }

  // Add product to cart
  static Future<void> addProduct({required CardModel product}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];

    int index = cartList.indexWhere((item) {
      Map<String, dynamic> existingItem = jsonDecode(item);
      return existingItem['productId'] ==
          product.productId; // Updated to productId
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
  }

// Remove product from cart
  static Future<void> removeProduct({required String productId}) async {
    // Changed parameter name to productId
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];
    cartList.removeWhere((item) =>
        jsonDecode(item)['productId'] == productId); // Updated to productId
    await prefs.setStringList(cartKey, cartList);
  }

// Update product quantity
  static Future<void> updateProductQuantity({
    required String productId, // Changed parameter name to productId
    required int quantityChange,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartList = prefs.getStringList(cartKey) ?? [];

    int index = cartList.indexWhere((item) {
      Map<String, dynamic> existingItem = jsonDecode(item);
      return existingItem['productId'] == productId; // Updated to productId
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
    } else {
      throw Exception(
          'Product with ID $productId not found in cart'); // Updated error message
    }
  }

// Get cart items with continuous yielding every 200 milliseconds
  static Stream<List<CardModel>> loadProductsStream() async* {
    while (true) {
      // Infinite loop to continuously yield
      final prefs = await SharedPreferences.getInstance();
      List<String> cartList = prefs.getStringList(cartKey) ?? [];

      List<CardModel> products = cartList.map((item) {
        Map<String, dynamic> decodedItem = jsonDecode(item);
        return CardModel.fromMap(decodedItem);
      }).toList();

      yield products;
      await Future.delayed(
          const Duration(milliseconds: 200)); // Wait 200ms before next yield
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

  // Calculate total price
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
  }
}
