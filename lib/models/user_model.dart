import 'package:flutter_application_1/enums/global_enums.dart';

class UserDetail {
  final String name;
  final String email;
  final String password;
  final String userId;
  final UserType userType;
  final String number;

  UserDetail({
    required this.name,
    required this.email,
    required this.password,
    required this.userId,
    required this.userType,
    required this.number,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userId': userId,
      'userType': userType.toString(),
      'number': number,
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
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userId': userId,
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
    );
  }
}
