import 'package:tournament_app/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_app/controllers/signup_controller.dart';
import 'package:tournament_app/services/auth_service.dart';
import 'package:tournament_app/screens/main_bottom_nav.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';

class SignUpScreen extends StatelessWidget {
  // Define colors based on the screenshot for easy theming
  final Color screenTopBackgroundColor = Colors.black;
  final Color formContainerColor = Color(
    0xFFF5F5F5,
  ); // Very light gray for the main form area
  final Color inputFieldFillColor = Color(
    0xFFEAEAEA,
  ); // Slightly darker gray for input field background
  final Color primaryTextColor =
      Colors.black; // For main text like "Sign up", input text
  final Color labelTextColor =
      Colors.grey[700]!; // For labels like "First Name"
  final Color buttonBackgroundColor = Colors.black;
  final Color buttonTextColor = Colors.white;
  final Color inputBorderColor = Colors.grey[400]!;

  @override
  Widget build(BuildContext context) {
    // Initialize GetX controller
    final SignUpController controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: screenTopBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: formContainerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Header: Back Arrow and "Sign up" Title
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              bottom: 10.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: primaryTextColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Sign up",
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),

                          // Form Fields
                          _buildTextField(
                            label: "Name",
                            controller: controller.nameController,
                            validator: controller.validateName,
                            inputFieldFillColor: inputFieldFillColor,
                            labelTextColor: labelTextColor,
                            primaryTextColor: primaryTextColor,
                            inputBorderColor: inputBorderColor,
                          ),
                          SizedBox(height: 18),
                          _buildTextField(
                            label: "Email",
                            controller: controller.emailController,
                            validator: controller.validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            inputFieldFillColor: inputFieldFillColor,
                            labelTextColor: labelTextColor,
                            primaryTextColor: primaryTextColor,
                            inputBorderColor: inputBorderColor,
                          ),
                          SizedBox(height: 18),
                          _buildTextField(
                            label: "Username",
                            controller: controller.usernameController,
                            validator: controller.validateUsername,
                            inputFieldFillColor: inputFieldFillColor,
                            labelTextColor: labelTextColor,
                            primaryTextColor: primaryTextColor,
                            inputBorderColor: inputBorderColor,
                          ),
                          SizedBox(height: 18),
                          _buildTextField(
                            label: "Phone Number",
                            controller: controller.phoneController,
                            validator: controller.validatePhone,
                            keyboardType: TextInputType.phone,
                            inputFieldFillColor: inputFieldFillColor,
                            labelTextColor: labelTextColor,
                            primaryTextColor: primaryTextColor,
                            inputBorderColor: inputBorderColor,
                          ),
                          SizedBox(height: 18),
                          Obx(
                            () => _buildTextField(
                              label: "Password",
                              controller: controller.passwordController,
                              validator: controller.validatePassword,
                              obscureText: !controller.isPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: labelTextColor,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              inputFieldFillColor: inputFieldFillColor,
                              labelTextColor: labelTextColor,
                              primaryTextColor: primaryTextColor,
                              inputBorderColor: inputBorderColor,
                            ),
                          ),
                          SizedBox(height: 18),
                          Obx(
                            () => _buildTextField(
                              label: "Confirm Password",
                              controller: controller.confirmPasswordController,
                              validator: controller.validateConfirmPassword,
                              obscureText:
                                  !controller.isConfirmPasswordVisible.value,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isConfirmPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: labelTextColor,
                                ),
                                onPressed:
                                    controller.toggleConfirmPasswordVisibility,
                              ),
                              inputFieldFillColor: inputFieldFillColor,
                              labelTextColor: labelTextColor,
                              primaryTextColor: primaryTextColor,
                              inputBorderColor: inputBorderColor,
                            ),
                          ),
                          SizedBox(height: 18),
                          _buildTextField(
                            label: "Referral Code (Optional)",
                            controller: controller.referralCodeController,
                            inputFieldFillColor: inputFieldFillColor,
                            labelTextColor: labelTextColor,
                            primaryTextColor: primaryTextColor,
                            inputBorderColor: inputBorderColor,
                          ),
                          SizedBox(height: 35),

                          // Register Button
                          Consumer<AuthService>(
                            builder: (context, authService, child) {
                              return Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap:
                                      authService.isLoading
                                          ? null
                                          : () => _handleSignUp(
                                            context,
                                            controller,
                                            authService,
                                          ),
                                  child: Container(
                                    width: 180,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color:
                                          authService.isLoading
                                              ? Colors.grey
                                              : Colors.black,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(20),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child:
                                          authService.isLoading
                                              ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : Text(
                                                "Register",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20),
                          // Already have an account? Login
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            LoginScreen(), // Navigate to LoginScreen
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Already have an account? ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "Login",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20), // Bottom padding
                        ],
                      ),
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

  // Handle signup process
  Future<void> _handleSignUp(
    BuildContext context,
    SignUpController controller,
    AuthService authService,
  ) async {
    if (!controller.formKey.currentState!.validate()) {
      if (context.mounted) {
        showSnackBarMessage(
          context,
          'Please fill all required fields correctly',
          type: SnackBarType.error,
        );
      }
      return;
    }

    // Clear any previous errors
    authService.clearError();

    final success = await authService.signUp(
      name: controller.nameController.text.trim(),
      email: controller.emailController.text.trim(),
      username: controller.usernameController.text.trim(),
      password: controller.passwordController.text.trim(),
      phone: controller.phoneController.text.trim(),
      referralCode:
          controller.referralCodeController.text.trim().isEmpty
              ? null
              : controller.referralCodeController.text.trim(),
    );

    if (!context.mounted) return;

    if (success) {
      showSnackBarMessage(
        context,
        'Account created successfully!',
        type: SnackBarType.success,
      );
      controller.clearForm();

      // Navigate to main app
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
        (route) => false,
      );
    } else {
      showSnackBarMessage(
        context,
        authService.errorMessage ?? 'Registration failed',
        type: SnackBarType.error,
      );
    }
  }

  // Helper widget for creating styled text fields
  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    required Color inputFieldFillColor,
    required Color labelTextColor,
    required Color primaryTextColor,
    required Color inputBorderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(color: primaryTextColor, fontSize: 16),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: labelTextColor),
            filled: true,
            fillColor: inputFieldFillColor,
            suffixIcon: suffixIcon,
            contentPadding: EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 12.0,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
