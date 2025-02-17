import 'package:flutter/material.dart';
import 'services/auth_service.dart';

// Exercise 2: Route Protection
// Implement route guards and authorization

// TODO: Implement route guard
abstract class RouteGuard {
  Future<bool> canActivate(
    BuildContext context,
    String route,
  );
}

class AuthGuard extends RouteGuard {
  final AuthService auth;
  final NavigationLogger logger;
  
  const AuthGuard({
    required this.auth,
    required this.logger,
  });
  
  @override
  Future<bool> canActivate(
    BuildContext context,
    String route,
  ) async {
    // TODO: Add guard methods
    // TODO: Add authorization checks
    // TODO: Add session handling
    return true;
  }
  
  // TODO: Add error handling methods
}

// Example protected route
class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement protected screen
    return Container();
  }
}

// Example settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement settings screen
    return Container();
  }
}

// Example admin screen
class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement admin screen
    return Container();
  }
}

// Example route configuration
class AppRouter {
  static final auth = AuthService();
  static final logger = NavigationLogger();
  static final authGuard = AuthGuard(
    auth: auth,
    logger: logger,
  );

  // TODO: Add route configuration
  // TODO: Add guard handling
  // TODO: Add error recovery
}

// Main app widget for testing
class Exercise2App extends StatelessWidget {
  const Exercise2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Lab - Exercise 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // TODO: Set up protected routes
      home: Container(),
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
