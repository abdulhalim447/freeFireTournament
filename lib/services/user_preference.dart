import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tournament_app/models/login_user_model.dart';

class UserPreference {
  static const String _keyUser = 'user';
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyAccessToken = 'access_token';
  static const String _keyTokenType = 'token_type';

  // Save user data
  static Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  // Get user data
  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userStr = prefs.getString(_keyUser);
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  // Save access token
  static Future<bool> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyAccessToken, token);
  }

  // Get access token
  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // Save token type
  static Future<bool> saveTokenType(String tokenType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_keyTokenType, tokenType);
  }

  // Get token type
  static Future<String?> getTokenType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTokenType);
  }

  // Get authorization header
  static Future<String?> getAuthorizationHeader() async {
    final tokenType = await getTokenType();
    final accessToken = await getAccessToken();

    // If token exists, use it
    if (tokenType != null && accessToken != null) {
      return '$tokenType $accessToken';
    }
    return null;
  }

  // Get user ID
  static Future<String?> getUserId() async {
    final user = await getUser();
    return user?.id?.toString();
  }

  // Get user balance
  static Future<String?> getUserBalance() async {
    final user = await getUser();
    return user?.balance;
  }

  // Get user phone
  static Future<String?> getUserPhone() async {
    final user = await getUser();
    return user?.phone;
  }

  // Get user email
  static Future<String?> getUserEmail() async {
    final user = await getUser();
    return user?.email;
  }

  // Get user name
  static Future<String?> getUserName() async {
    final user = await getUser();
    return user?.name;
  }

  // Get username
  static Future<String?> getUsername() async {
    final user = await getUser();
    return user?.username;
  }

  // Get referral code
  static Future<String?> getReferralCode() async {
    final user = await getUser();
    return user?.referralCode;
  }

  // Set logged in status
  static Future<bool> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_keyIsLoggedIn, value);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    final token = await getAccessToken();
    return isLoggedIn && token != null;
  }

  // Clear all user data
  static Future<void> clearUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyTokenType);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Update user balance (useful for real-time balance updates)
  static Future<bool> updateUserBalance(String newBalance) async {
    final user = await getUser();
    if (user != null) {
      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        username: user.username,
        balance: newBalance,
        phone: user.phone,
        avatar: user.avatar,
        isActive: user.isActive,
        referralCode: user.referralCode,
        referralCodeUsed: user.referralCodeUsed,
      );
      return await saveUser(updatedUser);
    }
    return false;
  }
}
