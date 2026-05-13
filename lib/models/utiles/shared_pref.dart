import 'package:shared_preferences/shared_preferences.dart';

class AuthPrefs {
  static const _emailKey = "email";
  static const _usernameKey = "username";

  static Future<void> setLoggedInUser({
    required String email,
    String? username,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_emailKey, email);

    if (username != null) {
      await prefs.setString(_usernameKey, username);
    }
  }

  static Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_usernameKey);
  }
}