import 'package:flutter_application_1/enums/global_enums.dart';

class CustomerModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String number;
  final String address; // ✅ New field
  final UserType userType;
  final bool? isEmailVerified;

  CustomerModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    required this.address, // ✅ Added to constructor
    this.isEmailVerified,
  }) : userType = UserType.customer;

  // ✅ Updated copyWith method
  CustomerModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? password,
    String? number,
    String? address,
    bool? isEmailVerified,
  }) {
    return CustomerModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      number: number ?? this.number,
      address: address ?? this.address,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'password': password,
      'number': number,
      'address': address, // ✅ Included
      'userType': userType.toString(),
    };
    if (isEmailVerified != null) {
      map['isEmailVerified'] = isEmailVerified;
    }
    return map;
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      number: map['number'] ?? '',
      address: map['address'] ?? '', // ✅ With fallback
      isEmailVerified: map['isEmailVerified'],
    );
  }

  // Customer-specific methods
  bool isValidCustomer() {
    return email.isNotEmpty &&
        password.length >= 6 &&
        name.length >= 3 &&
        number.length >= 11 &&
        address.isNotEmpty;
  }

  String getCustomerDisplayName() {
    return name.split(' ')[0]; // Returns first name
  }
}
