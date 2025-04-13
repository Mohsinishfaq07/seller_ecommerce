import 'package:flutter_application_1/enums/global_enums.dart';

class CustomerModel {
  final String userId;
  final String name;
  final String email;
  final String password;
  final String number;
  final UserType userType;
  final bool? isEmailVerified; // Made optional by adding '?'

  CustomerModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.number,
    this.isEmailVerified, // Now optional in the constructor
  }) : userType = UserType.customer;

  // Add the copyWith method
  CustomerModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? password,
    String? number,
    bool? isEmailVerified,
  }) {
    return CustomerModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      number: number ?? this.number,
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
      isEmailVerified: map['isEmailVerified'], // Can be null
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
