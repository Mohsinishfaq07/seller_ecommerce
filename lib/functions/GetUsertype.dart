import 'package:flutter_application_1/enums/global_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

void main() async {
  // Example usage:

  // Store a user type
  await UserTypePrefs.storeUserType(UserType.seller);
  print('User type stored successfully.');

  // Fetch the stored user type
  UserType? fetchedType = await UserTypePrefs.fetchUserType();
  print(
      'Fetched user type: $fetchedType'); // Output: Fetched user type: UserType.seller

  // Store a different user type
  await UserTypePrefs.storeUserType(UserType.admin);
  print('User type updated successfully.');

  // Fetch the updated user type
  fetchedType = await UserTypePrefs.fetchUserType();
  print(
      'Fetched user type: $fetchedType'); // Output: Fetched user type: UserType.admin

  // Clear the stored user type
  await UserTypePrefs.clearUserType();
  print('User type cleared.');

  // Try to fetch after clearing
  fetchedType = await UserTypePrefs.fetchUserType();
  print(
      'Fetched user type after clearing: $fetchedType'); // Output: Fetched user type after clearing: null
}
