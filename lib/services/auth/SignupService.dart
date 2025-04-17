
import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;
import 'package:shared_preferences/shared_preferences.dart';

enum ShopType {
  online,
  physical,
  both;

  String get displayName {
    switch (this) {
      case ShopType.online:
        return 'Online Shop';
      case ShopType.physical:
        return 'Physical Shop';
      case ShopType.both:
        return 'Both (Online & Physical)';
    }
  }
}

final shopTypeStateProvider = StateProvider<ShopType>((ref) => ShopType.online);
final showPasswordProvider = StateProvider<bool>((ref) => false);
// final userTypeProvider = StateProvider<UserType>((ref) => UserType.customer);

class UserTypePrefs {
  static const String _userTypeKey = 'userType';

  /// Stores the [UserType] in SharedPreferences.
  static Future<bool> storeUserType(UserType userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userTypeKey, userType.name);
  }

  /// Fetches the stored [UserType] from SharedPreferences.
  /// Returns null if no user type is stored.
  static Future<UserType?> fetchUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userTypeValue = prefs.getString(_userTypeKey);
    if (userTypeValue != null) {
      return UserType.values.firstWhere((type) => type.name == userTypeValue);
    }
    return null;
  }

  /// Clears the stored user type from SharedPreferences.
  static Future<bool> clearUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(_userTypeKey);
  }
}