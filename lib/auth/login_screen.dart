import 'package:flutter/material.dart';
import 'package:tournament_app/auth/signup_screen.dart';
import 'package:tournament_app/models/login_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/screens/main_bottom_nav.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Column(
        children: [
          const Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Sign in to continue",
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _usernameController,
                        label: 'Username',
                        prefixIcon: Icons.person_outline,
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_isPasswordVisible,
                        enabled: !_isLoading,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    // TODO: Implement forgot password
                                  },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 2,
                        ),
                        child:
                            _isLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                      const SizedBox(height: 24),
                      if (!_isLoading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

// methods are here

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearTextFields() {
    _usernameController.clear();
    _passwordController.clear();
    setState(() {
      _isPasswordVisible = false;
    });
  }

  Future<void> _handleLogin() async {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      try {
        setState(() => _isLoading = true);

        // Prepare login data
        final loginData = {
          'user_name': _usernameController.text.trim(),
          'password': _passwordController.text,
        };

        // Make API call
        final NetworkResponse response = await NetworkCaller.postRequest(
          URLs.loginUrl,
          body: loginData,
        );

        if (!mounted) return;

        if (response.isSuccess) {
          // Parse response
          final loginModel = LoginModel.fromJson(response.responsData);

          if (loginModel.success == true && loginModel.user != null) {
            // Save user data
            await UserPreference.saveUser(loginModel.user!);
            await UserPreference.setLoggedIn(true);

            // Clear fields
            _clearTextFields();

            // Show success message
            showSnackBarMessage(
              context,
              loginModel.message ?? 'Login successful!',
              type: SnackBarType.success,
            );

            // TODO: Navigate to home screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavScreen()),
            );
          } else {
            showSnackBarMessage(
              context,
              loginModel.message ?? 'Login failed',
              type: SnackBarType.error,
            );
          }
        } else {
          showSnackBarMessage(
            context,
            response.errorMessage ?? 'Login failed',
            type: SnackBarType.error,
          );
        }
      } catch (e) {
        if (!mounted) return;
        showSnackBarMessage(
          context,
          'Error: ${e.toString()}',
          type: SnackBarType.error,
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }







}
