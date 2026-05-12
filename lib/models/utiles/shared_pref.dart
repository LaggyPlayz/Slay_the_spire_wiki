import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefs{
  static const _usernameKey = "username";
  static const _emailKey = "email";
  static const _passKey = "password";

  static Future<void> saveUser({
    required String username,
    required String email,
    String? password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
    if (password != null) {
      await prefs.setString(_passKey, password);
    }
  }

  static Future<Map<String, String?>> getUser(

  ) async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "username": prefs.getString(_usernameKey),
      "email": prefs.getString(_emailKey),
      "password": prefs.getString(_passKey)
    };
  }

}
