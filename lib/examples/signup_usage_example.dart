// Example of how to use the new signup functionality
// This file demonstrates the integration of GetX and Provider for user registration

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tournament_app/auth/signup_screen.dart';
import 'package:tournament_app/services/auth_service.dart';

class SignUpUsageExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example 1: Navigate to signup screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Go to Signup Screen'),
            ),

            SizedBox(height: 20),

            // Example 2: Check authentication status using Provider
            Consumer<AuthService>(
              builder: (context, authService, child) {
                return Column(
                  children: [
                    Text(
                      'Auth Status: ${authService.isLoading ? "Loading..." : "Ready"}',
                    ),
                    if (authService.currentUser != null)
                      Text(
                        'Current User: ${authService.currentUser!.userName}',
                      ),
                    if (authService.errorMessage != null)
                      Text(
                        'Error: ${authService.errorMessage}',
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                );
              },
            ),

            SizedBox(height: 20),

            // Example 3: Manual signup using AuthService
            ElevatedButton(
              onPressed: () async {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );

                final success = await authService.signUp(
                  name: 'John Doe',
                  email: 'john.doe@example.com',
                  username: 'johndoe',
                  password: 'Password123',
                  phone: '1234567890',
                  referralCode: 'REF12365',
                );

                if (success) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Signup successful!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Signup failed: ${authService.errorMessage}',
                      ),
                    ),
                  );
                }
              },
              child: Text('Test Manual Signup'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example of how to initialize the app with proper providers
class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: GetMaterialApp(
        title: 'Tournament App',
        home: SignUpUsageExample(),
      ),
    );
  }
}
