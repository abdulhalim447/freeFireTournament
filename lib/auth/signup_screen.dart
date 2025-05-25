import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tournament_app/auth/login_screen.dart';
import 'package:tournament_app/network/network_response.dart';
import 'package:tournament_app/widgets/custom_button.dart';
import 'package:tournament_app/widgets/custom_text_field.dart';
import 'package:tournament_app/widgets/terms_checkbox.dart';
import 'package:tournament_app/models/signup_model.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referCodeController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers to prevent memory leaks
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _referCodeController.dispose();
    super.dispose();
  }

  // Validate email with proper regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  // Validate phone number
  bool _isValidPhone(String phone) {
    return phone.length >= 10 && phone.length <= 15;
  }

  void _clearTextFields() {
    _usernameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _referCodeController.clear();
    setState(() {
      _agreedToTerms = false;
      _isPasswordVisible = false;
    });
  }

  Future<void> _handleSignUp() async {
    if (!mounted) return;

    // First check terms agreement
    if (!_agreedToTerms) {
      showSnackBarMessage(
        context,
        'Please agree to Terms and Conditions',
        type: SnackBarType.error,
      );
      return;
    }

    // Then validate form
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() => _isLoading = true);

        // Create signup model
        final signUpData = SignUpModel(
          userName: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          mobileNumber: _phoneController.text.trim(),
          password: _passwordController.text,
          reffer: _referCodeController.text.trim(),
        );

        // Make API call
        final NetworkResponse response = await NetworkCaller.postRequest(
          URLs.signUpUrl,
          body: signUpData.toJson(),
        );

        if (!mounted) return;

        if (response.isSuccess) {
          // Clear all text fields
          _clearTextFields();

          // Show success message
          showSnackBarMessage(
            context,
            'Account created successfully!',
            type: SnackBarType.success,
          );

          // Navigate to login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        } else {
          // Show error message
          showSnackBarMessage(
            context,
            response.errorMessage ?? 'Failed to create account',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50),

      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's Start",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Create an account",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
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
                        CustomTextField(
                          controller: _usernameController,
                          label: 'Username',
                          prefixIcon: Icons.person_outline,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isLoading,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!_isValidEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Mobile Number',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          enabled: !_isLoading,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a phone number';
                            }
                            if (!_isValidPhone(value)) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
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
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _referCodeController,
                          label: 'Refer Code (Optional)',
                          prefixIcon: Icons.card_giftcard_outlined,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 24),
                        TermsCheckbox(
                          value: _agreedToTerms,
                          enabled: !_isLoading,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'Create Account',
                          onPressed: _handleSignUp,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: 24),
                        if (!_isLoading)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign In',
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
      ),
    );
  }
}
