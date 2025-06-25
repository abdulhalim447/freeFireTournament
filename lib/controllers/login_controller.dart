import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text editing controllers
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Observable variables
  var isPasswordVisible = false.obs;
  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to validate form in real-time
    loginController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    isFormValid.value = _isFormValid();
  }

  bool _isFormValid() {
    return loginController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        _isValidLogin(loginController.text.trim()) &&
        passwordController.text.trim().length >= 6;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validation methods
  String? validateLogin(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email, username, or phone is required';
    }
    if (!_isValidLogin(value.trim())) {
      return 'Please enter a valid email, username, or phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    }
    if (value.trim().length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Helper validation methods
  bool _isValidLogin(String login) {
    // Check if it's a valid email
    if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(login)) {
      return true;
    }
    
    // Check if it's a valid phone number (digits only, 10-15 characters)
    String cleanPhone = login.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length >= 10 && cleanPhone.length <= 15) {
      return true;
    }
    
    // Check if it's a valid username (alphanumeric and underscore, 3-20 characters)
    if (RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(login)) {
      return true;
    }
    
    return false;
  }

  void clearForm() {
    loginController.clear();
    passwordController.clear();
    isPasswordVisible.value = false;
    isFormValid.value = false;
  }

  @override
  void onClose() {
    loginController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
