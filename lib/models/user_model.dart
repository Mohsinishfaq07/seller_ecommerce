import 'package:flutter_application_1/enums/global_enums.dart';

class UserDetail {
  final String name;
  final String email;
  final String password;
  final String userId;
  final UserType userType;
  final String number;
  final String address; // ✅ New field

  UserDetail({
    required this.name,
    required this.email,
    required this.password,
    required this.userId,
    required this.userType,
    required this.number,
    required this.address, // ✅ New parameter
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userId': userId,
      'userType': userType.toString(),
      'number': number,
      'address': address, // ✅ Added to map
    };
  }

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      userId: map['userId'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == map['userType'],
        orElse: () => UserType.customer,
      ),
      number: map['number'],
      address: map['address'] ?? '', // ✅ With fallback
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userId': userId,
      'userType': userType.toString(), // ✅ Added for consistency
      'number': number,
      'address': address, // ✅ New field
    };
  }

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      userId: json['userId'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == json['userType'],
        orElse: () => UserType.customer,
      ),
      number: json['number'],
      address: json['address'] ?? '', // ✅ With fallback
    );
  }
}
