import 'package:flutter/foundation.dart';
import 'package:tournament_app/models/signup_response_model.dart';
import 'package:tournament_app/models/login_model.dart';
import 'package:tournament_app/models/login_user_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/utils/urls.dart';

class AuthService extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  String? _lastRegisteredPhone;
  String? _lastRegisteredPassword;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  String? get lastRegisteredPhone => _lastRegisteredPhone;
  String? get lastRegisteredPassword => _lastRegisteredPassword;

  // Clear registration data after login
  void clearRegistrationData() {
    _lastRegisteredPhone = null;
    _lastRegisteredPassword = null;
  }

  // Initialize auth state on app startup
  Future<void> initAuthState() async {
    debugPrint('=== Initializing Auth State ===');
    final isLoggedIn = await UserPreference.isLoggedIn();
    debugPrint('=== Is Logged In: $isLoggedIn ===');

    if (isLoggedIn) {
      final user = await UserPreference.getUser();
      if (user != null) {
        _currentUser = user;
        debugPrint('=== Current User Set: ${user.name} ===');

        // Verify token is valid by making a test API call
        final token = await UserPreference.getAccessToken();
        debugPrint('=== Stored Token: $token ===');

        // Check if token is valid by making a simple API call
        final response = await NetworkCaller.getRequest(URLs.profileUrl);
        if (!response.isSuccess) {
          debugPrint('=== Token validation failed, logging out ===');
          await logout();
        } else {
          debugPrint('=== Token validated successfully ===');
        }
      } else {
        debugPrint('=== No user found in preferences, logging out ===');
        await logout();
      }
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String username,
    required String password,
    required String phone,
    String? referralCode,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Create the signup model based on the exact API structure
      final signupData = {
        'name': name,
        'email': email,
        'username': username,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
        'referral_code_used': referralCode,
      };

      debugPrint('Signup data: $signupData');

      final response = await NetworkCaller.postRequest(
        URLs.signUpUrl,
        body: signupData,
      );

      if (response.isSuccess) {
        final signupResponse = SignUpResponseModel.fromJson(
          response.responsData,
        );

        if (signupResponse.isSuccess && signupResponse.user != null) {
          // Don't save user data or tokens - just return success
          // We'll store the phone number and password temporarily for login screen
          _lastRegisteredPhone = phone;
          _lastRegisteredPassword = password;

          _setLoading(false);
          return true;
        } else {
          _setError(signupResponse.message ?? 'Registration failed');
          _setLoading(false);
          return false;
        }
      } else {
        _setError(response.errorMessage ?? 'Network error occurred');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> login({required String login, required String password}) async {
    _setLoading(true);
    _setError(null);

    try {
      final loginData = {'login': login, 'password': password};

      print('Login data: $loginData');

      final response = await NetworkCaller.postRequest(
        URLs.loginUrl,
        body: loginData,
      );

      if (response.isSuccess) {
        final loginResponse = LoginModel.fromJson(response.responsData);

        if (loginResponse.isSuccess && loginResponse.user != null) {
          _currentUser = loginResponse.user;

          // Save user data and tokens
          await UserPreference.saveUser(loginResponse.user!);
          if (loginResponse.accessToken != null) {
            await UserPreference.saveAccessToken(loginResponse.accessToken!);
          }
          if (loginResponse.tokenType != null) {
            await UserPreference.saveTokenType(loginResponse.tokenType!);
          }
          await UserPreference.setLoggedIn(true);

          _setLoading(false);
          return true;
        } else {
          _setError(loginResponse.message ?? 'Login failed');
          _setLoading(false);
          return false;
        }
      } else {
        _setError(response.errorMessage ?? 'Network error occurred');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await UserPreference.clearUser();
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    final user = await UserPreference.getUser();
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }

  // Get current user balance
  Future<String?> getCurrentUserBalance() async {
    if (_currentUser != null) {
      return _currentUser!.balance;
    }
    return await UserPreference.getUserBalance();
  }

  // Update user balance
  Future<void> updateUserBalance(String newBalance) async {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        username: _currentUser!.username,
        balance: newBalance,
        phone: _currentUser!.phone,
        avatar: _currentUser!.avatar,
        isActive: _currentUser!.isActive,
        referralCode: _currentUser!.referralCode,
        referralCodeUsed: _currentUser!.referralCodeUsed,
      );
      await UserPreference.updateUserBalance(newBalance);
      notifyListeners();
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await UserPreference.isLoggedIn();
  }

  // Get authorization header for API calls
  Future<String?> getAuthorizationHeader() async {
    return await UserPreference.getAuthorizationHeader();
  }
}
