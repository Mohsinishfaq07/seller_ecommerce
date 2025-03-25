import 'package:flutter_application_1/enums/global_enums.dart';

class CustomerModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String number;
  final UserType userType;

  CustomerModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.number,
  }) : userType = UserType.customer;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'number': number,
      'userType': userType.toString(),
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      number: map['number'] ?? '',
    );
  }

  // Customer-specific methods
  bool isValidCustomer() {
    return email.isNotEmpty &&
        password.length >= 6 &&
        name.length >= 3 &&
        number.length >= 11;
  }

  String getCustomerDisplayName() {
    return name.split(' ')[0]; // Returns first name
  }
}
