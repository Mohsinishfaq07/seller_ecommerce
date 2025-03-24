import 'package:flutter_application_1/enums/global_enums.dart';

class UserDetail {
  String name;
  String email;
  String password;
  String userId;
  UserType userType;
  String number;

  UserDetail({
    required this.name,
    required this.email,
    required this.password,
    required this.userId,
    required this.userType,
    required this.number,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'userId': userId,
      'userType': userType.name,
      'number': number,
    };
  }

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      userId: json['userId'],
      number: json['number'],
      userType: UserType.values.firstWhere(
        (e) => e.name == json['userType'],
        orElse: () => UserType.admin,
      ),
    );
  }
}
