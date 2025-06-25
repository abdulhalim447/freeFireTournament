// Utility class for easy user data access throughout the application
// This provides a simple interface to access user data from anywhere in the codebase

import 'package:tournament_app/models/login_user_model.dart';
import 'package:tournament_app/services/user_preference.dart';

class UserUtils {
  // Private constructor to prevent instantiation
  UserUtils._();

  /// Get the complete user object
  static Future<User?> getCurrentUser() async {
    return await UserPreference.getUser();
  }

  /// Get user ID as string
  static Future<String?> getUserId() async {
    return await UserPreference.getUserId();
  }

  /// Get user name
  static Future<String?> getUserName() async {
    return await UserPreference.getUserName();
  }

  /// Get user email
  static Future<String?> getUserEmail() async {
    return await UserPreference.getUserEmail();
  }

  /// Get username
  static Future<String?> getUsername() async {
    return await UserPreference.getUsername();
  }

  /// Get user phone number
  static Future<String?> getUserPhone() async {
    return await UserPreference.getUserPhone();
  }

  /// Get user balance
  static Future<String?> getUserBalance() async {
    return await UserPreference.getUserBalance();
  }

  /// Get user balance as double
  static Future<double> getUserBalanceAsDouble() async {
    final balance = await UserPreference.getUserBalance();
    return double.tryParse(balance ?? '0.0') ?? 0.0;
  }

  /// Get user referral code
  static Future<String?> getReferralCode() async {
    return await UserPreference.getReferralCode();
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    return await UserPreference.getAccessToken();
  }

  /// Get authorization header for API calls
  static Future<String?> getAuthorizationHeader() async {
    return await UserPreference.getAuthorizationHeader();
  }

  /// Get headers for authenticated API calls
  static Future<Map<String, String>> getApiHeaders() async {
    final authHeader = await UserPreference.getAuthorizationHeader();
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (authHeader != null) {
      headers['Authorization'] = authHeader;
    }
    
    return headers;
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    return await UserPreference.isLoggedIn();
  }

  /// Check if user is active
  static Future<bool> isUserActive() async {
    final user = await getCurrentUser();
    return user?.isActive == 1;
  }

  /// Get user display name (name or username)
  static Future<String> getDisplayName() async {
    final user = await getCurrentUser();
    return user?.name ?? user?.username ?? 'User';
  }

  /// Get formatted balance string
  static Future<String> getFormattedBalance() async {
    final balance = await getUserBalance();
    final balanceDouble = double.tryParse(balance ?? '0.0') ?? 0.0;
    return '\$${balanceDouble.toStringAsFixed(2)}';
  }

  /// Update user balance
  static Future<bool> updateBalance(String newBalance) async {
    return await UserPreference.updateUserBalance(newBalance);
  }

  /// Clear all user data (logout)
  static Future<void> clearUserData() async {
    await UserPreference.clearUser();
  }

  /// Get user initials for avatar
  static Future<String> getUserInitials() async {
    final user = await getCurrentUser();
    final name = user?.name ?? user?.username ?? 'U';
    final parts = name.split(' ');
    
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    
    return 'U';
  }

  /// Check if user has avatar
  static Future<bool> hasAvatar() async {
    final user = await getCurrentUser();
    return user?.avatar != null && user!.avatar!.isNotEmpty;
  }

  /// Get avatar URL or null
  static Future<String?> getAvatarUrl() async {
    final user = await getCurrentUser();
    return user?.avatar;
  }

  /// Get user info summary for display
  static Future<Map<String, String?>> getUserSummary() async {
    final user = await getCurrentUser();
    return {
      'id': user?.id?.toString(),
      'name': user?.name,
      'email': user?.email,
      'username': user?.username,
      'phone': user?.phone,
      'balance': user?.balance,
      'referralCode': user?.referralCode,
      'isActive': user?.isActive == 1 ? 'Yes' : 'No',
    };
  }

  /// Validate if user session is still valid
  static Future<bool> isSessionValid() async {
    final isLoggedIn = await UserPreference.isLoggedIn();
    final token = await getAccessToken();
    final user = await getCurrentUser();
    
    return isLoggedIn && token != null && user != null;
  }

  /// Get user contact info
  static Future<Map<String, String?>> getContactInfo() async {
    final user = await getCurrentUser();
    return {
      'email': user?.email,
      'phone': user?.phone,
    };
  }

  /// Check if user has sufficient balance
  static Future<bool> hasSufficientBalance(double requiredAmount) async {
    final balance = await getUserBalanceAsDouble();
    return balance >= requiredAmount;
  }

  /// Get user account status
  static Future<String> getAccountStatus() async {
    final user = await getCurrentUser();
    if (user == null) return 'Not logged in';
    if (user.isActive == 1) return 'Active';
    return 'Inactive';
  }

  /// Format user info for display
  static Future<String> getFormattedUserInfo() async {
    final user = await getCurrentUser();
    if (user == null) return 'Guest User';
    
    final name = user.name ?? user.username ?? 'User';
    final balance = await getFormattedBalance();
    
    return '$name • $balance';
  }

  /// Get user registration info
  static Future<Map<String, String?>> getRegistrationInfo() async {
    final user = await getCurrentUser();
    return {
      'referralCode': user?.referralCode,
      'referralCodeUsed': user?.referralCodeUsed,
    };
  }

  /// Debug method to print all user data
  static Future<void> debugPrintUserData() async {
    final user = await getCurrentUser();
    final token = await getAccessToken();
    
    print('=== USER DATA DEBUG ===');
    print('User: ${user?.toJson()}');
    print('Token: $token');
    print('Is Logged In: ${await isLoggedIn()}');
    print('=====================');
  }
}

// Extension methods for easier access
extension UserExtensions on User {
  /// Get display name
  String get displayName => name ?? username ?? 'User';
  
  /// Get initials
  String get initials {
    final displayName = this.displayName;
    final parts = displayName.split(' ');
    
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    
    return 'U';
  }
  
  /// Check if user is active
  bool get isActiveUser => isActive == 1;
  
  /// Get formatted balance
  String get formattedBalance {
    final balanceDouble = double.tryParse(balance ?? '0.0') ?? 0.0;
    return '\$${balanceDouble.toStringAsFixed(2)}';
  }
  
  /// Check if user has avatar
  bool get hasAvatar => avatar != null && avatar!.isNotEmpty;
}
