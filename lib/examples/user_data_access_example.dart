// Example of how to access user data from anywhere in the codebase
// This demonstrates various ways to get user information using both Provider and UserPreference

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/services/auth_service.dart';
import 'package:tournament_app/services/user_preference.dart';
import 'package:tournament_app/models/login_user_model.dart';

class UserDataAccessExample extends StatefulWidget {
  @override
  _UserDataAccessExampleState createState() => _UserDataAccessExampleState();
}

class _UserDataAccessExampleState extends State<UserDataAccessExample> {
  User? _user;
  String? _balance;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Method 1: Using UserPreference directly (can be called from anywhere)
  Future<void> _loadUserData() async {
    final user = await UserPreference.getUser();
    final balance = await UserPreference.getUserBalance();
    final token = await UserPreference.getAccessToken();
    
    setState(() {
      _user = user;
      _balance = balance;
      _token = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data Access Examples'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Method 2: Using Provider (reactive to changes)
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Method 1: Using Provider (Reactive)', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Consumer<AuthService>(
                      builder: (context, authService, child) {
                        final user = authService.currentUser;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User ID: ${user?.id ?? "Not logged in"}'),
                            Text('Name: ${user?.name ?? "N/A"}'),
                            Text('Email: ${user?.email ?? "N/A"}'),
                            Text('Username: ${user?.username ?? "N/A"}'),
                            Text('Phone: ${user?.phone ?? "N/A"}'),
                            Text('Balance: \$${user?.balance ?? "0.00"}'),
                            Text('Referral Code: ${user?.referralCode ?? "N/A"}'),
                            Text('Is Active: ${user?.isActive == 1 ? "Yes" : "No"}'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Method 3: Using UserPreference directly
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Method 2: Using UserPreference (Direct Access)', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('User ID: ${_user?.id ?? "Not logged in"}'),
                    Text('Name: ${_user?.name ?? "N/A"}'),
                    Text('Email: ${_user?.email ?? "N/A"}'),
                    Text('Username: ${_user?.username ?? "N/A"}'),
                    Text('Phone: ${_user?.phone ?? "N/A"}'),
                    Text('Balance: \$${_balance ?? "0.00"}'),
                    Text('Referral Code: ${_user?.referralCode ?? "N/A"}'),
                    Text('Access Token: ${_token != null ? "Available" : "Not available"}'),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Method 4: Individual data access methods
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Method 3: Individual Access Methods', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final userId = await UserPreference.getUserId();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User ID: ${userId ?? "Not found"}')),
                        );
                      },
                      child: Text('Get User ID'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final userName = await UserPreference.getUserName();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User Name: ${userName ?? "Not found"}')),
                        );
                      },
                      child: Text('Get User Name'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final userEmail = await UserPreference.getUserEmail();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User Email: ${userEmail ?? "Not found"}')),
                        );
                      },
                      child: Text('Get User Email'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final userPhone = await UserPreference.getUserPhone();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('User Phone: ${userPhone ?? "Not found"}')),
                        );
                      },
                      child: Text('Get User Phone'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final balance = await UserPreference.getUserBalance();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Balance: \$${balance ?? "0.00"}')),
                        );
                      },
                      child: Text('Get Balance'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final referralCode = await UserPreference.getReferralCode();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Referral Code: ${referralCode ?? "Not found"}')),
                        );
                      },
                      child: Text('Get Referral Code'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final authHeader = await UserPreference.getAuthorizationHeader();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Auth Header: ${authHeader != null ? "Available" : "Not available"}')),
                        );
                      },
                      child: Text('Get Auth Header'),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Method 5: Update balance example
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Method 4: Update User Data', 
                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        // Example: Update user balance
                        final authService = Provider.of<AuthService>(context, listen: false);
                        await authService.updateUserBalance('150.00');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Balance updated to \$150.00')),
                        );
                        _loadUserData(); // Refresh local data
                      },
                      child: Text('Update Balance to \$150.00'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Example: Check if user is authenticated
                        final authService = Provider.of<AuthService>(context, listen: false);
                        final isAuth = await authService.isAuthenticated();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Is Authenticated: $isAuth')),
                        );
                      },
                      child: Text('Check Authentication'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Example: Logout
                        final authService = Provider.of<AuthService>(context, listen: false);
                        await authService.logout();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Logged out successfully')),
                        );
                        _loadUserData(); // Refresh local data
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _loadUserData,
              child: Text('Refresh Data'),
            ),
          ],
        ),
      ),
    );
  }
}

// Static helper class for easy access from anywhere
class UserDataHelper {
  // Quick access methods that can be called from anywhere
  static Future<String?> getCurrentUserId() async {
    return await UserPreference.getUserId();
  }
  
  static Future<String?> getCurrentUserName() async {
    return await UserPreference.getUserName();
  }
  
  static Future<String?> getCurrentUserEmail() async {
    return await UserPreference.getUserEmail();
  }
  
  static Future<String?> getCurrentUserBalance() async {
    return await UserPreference.getUserBalance();
  }
  
  static Future<bool> isUserLoggedIn() async {
    return await UserPreference.isLoggedIn();
  }
  
  static Future<String?> getAuthToken() async {
    return await UserPreference.getAccessToken();
  }
  
  static Future<Map<String, String>> getAuthHeaders() async {
    final authHeader = await UserPreference.getAuthorizationHeader();
    if (authHeader != null) {
      return {
        'Authorization': authHeader,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
    }
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}
