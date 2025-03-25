import 'package:flutter_application_1/enums/global_enums.dart';

class SellerModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String number;
  final String shopName;
  final String shopType;
  final UserType userType;
  final bool approved;

  SellerModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    required this.shopName,
    required this.shopType,
    required this.approved,
  }) : userType = UserType.seller;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'number': number,
      'userType': userType.toString(),
      'shopName': shopName,
      'shopType': shopType,
      'approved': false,
    };
  }

  factory SellerModel.fromMap(Map<String, dynamic> map) {
    return SellerModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      number: map['number'] ?? '',
      shopName: map['shopName'] ?? '',
      shopType: map['shopType'] ?? '',
      approved: map['approved'] ?? false,
    );
  }

  // Seller-specific methods
  bool isValidSeller() {
    return email.isNotEmpty &&
        password.length >= 6 &&
        name.length >= 3 &&
        number.length >= 11 &&
        shopName.isNotEmpty &&
        shopType.isNotEmpty;
  }

  String getShopDisplayName() {
    return shopName;
  }

  bool isShopOpen() {
    // Add your shop open/close logic here
    return true;
  }
}
