# Signup Form API Structure Update

This document outlines the changes made to align the signup form with the exact API requirements.

## 🔄 Changes Made

### **1. Updated Form Fields**

**Before (Separate Fields):**
- First Name
- Last Name  
- Email
- Phone Number
- Password
- Confirm Password
- Referral Code (Optional)

**After (API-Aligned Fields):**
- **Name** (single field instead of separate first/last name)
- **Email**
- **Username** (newly added required field)
- **Phone Number**
- **Password**
- **Confirm Password**
- **Referral Code** (optional/nullable)

### **2. Updated API Request Structure**

**New API Request Format:**
```json
{
  "name": "naeem",
  "email": "halimbacu@gmail.com",
  "username": "naeem", 
  "phone": "01780998480",
  "password": "password123",
  "password_confirmation": "password123",
  "referral_code_used": "REF12355"
}
```

### **3. Controller Updates**

**SignUpController Changes:**
- Replaced `firstNameController` and `lastNameController` with `nameController`
- Added `usernameController`
- Updated validation methods:
  - `validateName()` - validates single name field
  - `validateUsername()` - validates username format (3-20 chars, alphanumeric + underscore)
- Updated form validation logic to include username validation

### **4. AuthService Updates**

**Method Signature Changed:**
```dart
// Before
Future<bool> signUp({
  required String firstName,
  required String lastName,
  required String email,
  required String password,
  required String phone,
  String? referralCode,
})

// After  
Future<bool> signUp({
  required String name,
  required String email,
  required String username,
  required String password,
  required String phone,
  String? referralCode,
})
```

**API Request Data:**
```dart
final signupData = {
  'name': name,                    // Direct name field
  'email': email,
  'username': username,            // New required field
  'phone': phone,
  'password': password,
  'password_confirmation': password,
  'referral_code_used': referralCode, // Can be null
};
```

## 📱 Updated UI Form

The signup screen now displays:

1. **Name** - Single field for full name
2. **Email** - Email address with validation
3. **Username** - Unique username (3-20 characters, alphanumeric + underscore)
4. **Phone Number** - Phone number with validation
5. **Password** - Password with strength validation and visibility toggle
6. **Confirm Password** - Password confirmation with visibility toggle
7. **Referral Code** - Optional field

## ✅ Validation Rules

### **Name Field:**
- Required
- Minimum 2 characters

### **Username Field:**
- Required
- 3-20 characters
- Alphanumeric characters and underscore only
- Pattern: `^[a-zA-Z0-9_]{3,20}$`

### **Email Field:**
- Required
- Valid email format
- Pattern: `^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$`

### **Phone Field:**
- Required
- 10-15 digits (non-digit characters removed for validation)

### **Password Field:**
- Required
- Minimum 8 characters
- Must contain: uppercase, lowercase, and number

### **Referral Code:**
- Optional
- Can be null/empty

## 🔗 API Integration

**Endpoint:** `POST {{baseUrl}}/register`

**Headers:**
```json
{
  "Content-Type": "application/json",
  "Accept": "application/json"
}
```

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "username": "johndoe",
  "phone": "1234567890",
  "password": "Password123",
  "password_confirmation": "Password123",
  "referral_code_used": null
}
```

## 🚀 Usage Example

```dart
// Using the updated signup method
final success = await authService.signUp(
  name: 'John Doe',
  email: 'john@example.com',
  username: 'johndoe',
  password: 'Password123',
  phone: '1234567890',
  referralCode: 'REF12355', // Optional
);
```

## 📋 Files Modified

1. **`lib/controllers/signup_controller.dart`**
   - Updated text controllers
   - Added username validation
   - Updated form validation logic

2. **`lib/services/auth_service.dart`**
   - Updated signUp method parameters
   - Updated API request structure
   - Removed default referral code logic

3. **`lib/auth/signup_screen.dart`**
   - Updated form fields
   - Added username field
   - Updated API call parameters

4. **`lib/examples/signup_usage_example.dart`**
   - Updated example to use new parameters

## ✨ Key Improvements

1. **API Compliance**: Form now exactly matches API requirements
2. **Better UX**: Single name field is more user-friendly
3. **Username Support**: Added proper username field with validation
4. **Flexible Referral**: Referral code can be null as per API spec
5. **Validation**: Comprehensive validation for all fields
6. **Type Safety**: Strong typing throughout the implementation

## 🔧 Testing

To test the updated signup form:

1. Fill in all required fields (name, email, username, phone, password, confirm password)
2. Optionally add a referral code
3. Submit the form
4. Verify the API request matches the expected structure
5. Check that user data is properly saved after successful registration

The implementation now perfectly aligns with the API specification and provides a seamless user experience!
