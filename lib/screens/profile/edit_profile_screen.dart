import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/network/network_caller.dart';
import 'package:tournament_app/utils/urls.dart';
import 'package:tournament_app/widgets/show_snackbar.dart';
import 'package:tournament_app/models/login_user_model.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/providers/profile_provider.dart';

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
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _referralCodeUsedController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    if (profileProvider.profileData == null) {
      await profileProvider.getUserProfile();
    }
    final user = profileProvider.profileData?.user;
    if (user != null) {
      _userNameController.text = user.username;
      _emailController.text = user.email;
      _mobileController.text = user.phone;
      _referralCodeUsedController.text = user.referralCodeUsed ?? '';
    }
    setState(() {});
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _referralCodeUsedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
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
        actions: [
          IconButton(
            icon:
                _isLoading
                    ? CircularProgressIndicator(color: Colors.black)
                    : Icon(Icons.save, color: Colors.black),
            onPressed: _isLoading ? null : _handleSaveProfile,
            tooltip: 'Save',
          ),
        ],
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
                _buildInputLabel('User Name', textScaleFactor),
                TextFormField(
                  controller: _userNameController,
                  readOnly: false,
                  style: TextStyle(
                    fontSize: 16 * textScaleFactor,
                    color: Colors.black,
                  ),
                  decoration: _inputDecoration(),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: verticalPadding),
                _buildInputLabel('Email', textScaleFactor),
                TextFormField(
                  controller: _emailController,
                  readOnly: false,
                  style: TextStyle(
                    fontSize: 16 * textScaleFactor,
                    color: Colors.black,
                  ),
                  decoration: _inputDecoration(),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: verticalPadding),
                _buildInputLabel('Mobile Number', textScaleFactor),
                TextFormField(
                  controller: _mobileController,
                  readOnly: false,
                  style: TextStyle(
                    fontSize: 16 * textScaleFactor,
                    color: Colors.black,
                  ),
                  decoration: _inputDecoration(),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: verticalPadding),
                _buildInputLabel(
                  'Referral Code Used (optional)',
                  textScaleFactor,
                ),
                TextFormField(
                  controller: _referralCodeUsedController,
                  readOnly: false,
                  style: TextStyle(
                    fontSize: 16 * textScaleFactor,
                    color: Colors.black,
                  ),
                  decoration: _inputDecoration(),
                ),
                SizedBox(height: sectionSpacing * 1.5),
                _buildSectionTitle('PASSWORD CHANGE', textScaleFactor),
                SizedBox(height: sectionSpacing),
                _buildPasswordField(
                  controller: _oldPasswordController,
                  hintText: 'OldPassword',
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: verticalPadding),
                _buildPasswordField(
                  controller: _newPasswordController,
                  hintText: 'NewPassword',
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: verticalPadding),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  textScaleFactor: textScaleFactor,
                ),
                SizedBox(height: sectionSpacing * 1.5),
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
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

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final user = profileProvider.profileData?.user;
    if (user == null) {
      showSnackBarMessage(context, 'User not found', type: SnackBarType.error);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final response = await NetworkCaller.postRequest(
      URLs.updateProfileUrl,
      body: {
        'name': user.name,
        'email': _emailController.text.trim(),
        'username': _userNameController.text.trim(),
        'phone': _mobileController.text.trim(),
        'referral_code_used':
            _referralCodeUsedController.text.trim().isEmpty
                ? null
                : _referralCodeUsedController.text.trim(),
      },
    );
    setState(() {
      _isLoading = false;
    });
    if (response.isSuccess) {
      // Optionally refresh profile provider
      await profileProvider.getUserProfile();
      showSnackBarMessage(
        context,
        'Profile updated successfully',
        type: SnackBarType.success,
      );
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage ?? 'Failed to update profile',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _handleChangePassword() async {
    // Only validate password fields, not the whole form
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      showSnackBarMessage(
        context,
        'All password fields are required',
        type: SnackBarType.error,
      );
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      showSnackBarMessage(
        context,
        'New password and confirm password do not match',
        type: SnackBarType.error,
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    final user = profileProvider.profileData?.user;
    if (user == null) {
      showSnackBarMessage(context, 'User not found', type: SnackBarType.error);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final response = await NetworkCaller.postRequest(
      URLs.updateProfileUrl,
      body: {
        'name': user.name,
        'email': user.email,
        'username': user.username,
        'phone': user.phone,
        'password': _newPasswordController.text,
        'password_confirmation': _confirmPasswordController.text,
      },
    );
    setState(() {
      _isLoading = false;
    });
    if (response.isSuccess) {
      await profileProvider.getUserProfile();
      showSnackBarMessage(
        context,
        'Password changed successfully',
        type: SnackBarType.success,
      );
      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage ?? 'Failed to change password',
        type: SnackBarType.error,
      );
    }
  }
}
