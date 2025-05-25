import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tournament_app/models/login_user_model.dart';

class UserPreference {
  static const String _keyUser = 'user';
  static const String _keyIsLoggedIn = 'isLoggedIn';

  static Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userStr = prefs.getString(_keyUser);
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  static Future<bool> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_keyIsLoggedIn, value);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.setBool(_keyIsLoggedIn, false);
  }
}
