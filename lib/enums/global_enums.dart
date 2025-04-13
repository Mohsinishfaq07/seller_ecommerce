import 'package:shared_preferences/shared_preferences.dart';

enum UserType {
  customer,
  seller,
  admin,
}

enum ToastType {
  success,
  error,
  info,
}

enum OrderStatus { active, processing, dispatched }

class UserTypePrefs {
  static const String _userTypeKey = 'userType';
  static Future<bool> storeUserType(UserType userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userTypeKey, userType.name);
  }

  static Future<UserType?> fetchUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userTypeValue = prefs.getString(_userTypeKey);
    if (userTypeValue != null) {
      return UserType.values.firstWhere((type) => type.name == userTypeValue);
    }
    return null;
  }
}
