import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Calculate responsive padding and sizes
    final horizontalPadding = size.width * 0.05;
    final verticalPadding = size.height * 0.02;
    final sectionSpacing = size.height * 0.03;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20 * textScaleFactor,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('BASIC DETAILS', textScaleFactor),
                SizedBox(height: sectionSpacing),

                // User Name Field
                _buildInputLabel('User Name', textScaleFactor),
                _buildTextField(
                  initialValue: 'baccu',
                  readOnly: true,
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: verticalPadding),

                // Email Field
                _buildInputLabel('Email', textScaleFactor),
                _buildTextField(
                  initialValue: 'nodirahman793@gmail.com',
                  readOnly: true,
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: verticalPadding),

                // Mobile Number Field
                _buildInputLabel('Mobile Number', textScaleFactor),
                _buildTextField(
                  initialValue: '0178099848',
                  readOnly: true,
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: sectionSpacing * 1.5),

                // Password Change Section
                _buildSectionTitle('PASSWORD CHANGE', textScaleFactor),
                SizedBox(height: sectionSpacing),

                // Old Password Field
                _buildPasswordField(
                  controller: _oldPasswordController,
                  hintText: 'OldPassword',
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: verticalPadding),

                // New Password Field
                _buildPasswordField(
                  controller: _newPasswordController,
                  hintText: 'NewPassword',
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: verticalPadding),

                // Confirm Password Field
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: sectionSpacing * 1.5),

                // Change Password Button
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: _handleChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 16 * textScaleFactor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double textScaleFactor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18 * textScaleFactor,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInputLabel(String label, double textScaleFactor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16 * textScaleFactor,
          fontWeight: FontWeight.w500,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String initialValue,
    required bool readOnly,
    required double textScaleFactor,
  }) {
    return TextFormField(
      initialValue: initialValue,
      readOnly: readOnly,
      style: TextStyle(fontSize: 16 * textScaleFactor, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required double textScaleFactor,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      style: TextStyle(fontSize: 16 * textScaleFactor, color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16 * textScaleFactor,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement password change logic
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New password and confirm password do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show success message (temporary, replace with actual API call)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
