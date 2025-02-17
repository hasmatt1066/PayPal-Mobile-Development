import 'package:flutter/material.dart';
import 'services/auth_service.dart';

// Exercise 1: Secure Navigation
// Implement secure navigation patterns for financial applications

// TODO: Implement secure navigator
class SecureNavigator {
  final BuildContext context;
  final AuthService auth;
  final NavigationLogger logger;
  
  const SecureNavigator({
    required this.context,
    required this.auth,
    required this.logger,
  });
  
  // TODO: Add secure navigation methods
  Future<void> navigateToSecure(
    String route, {
    Object? arguments,
    bool requireAuth = true,
  }) async {
    // TODO: Implement secure navigation
  }
  
  // TODO: Add authentication checks
  Future<void> _handleSessionExpired() async {
    // TODO: Implement session handling
  }
  
  // TODO: Add error handling
  void _showError(String message) {
    // TODO: Implement error display
  }
}

// Example screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement home screen with navigation
    return Container();
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement login screen
    return Container();
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement protected account screen
    return Container();
  }
}

class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement session expired dialog
    return Container();
  }
}

// Main app widget for testing
class Exercise1App extends StatelessWidget {
  const Exercise1App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Lab - Exercise 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // TODO: Set up navigation
      home: const HomeScreen(),
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
