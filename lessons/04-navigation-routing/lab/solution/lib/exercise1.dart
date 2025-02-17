import 'package:flutter/material.dart';
import 'services/auth_service.dart';

// Exercise 1: Secure Navigation
// Implementation of secure navigation patterns for financial applications

class SecureNavigator {
  final BuildContext context;
  final AuthService auth;
  final NavigationLogger logger;
  
  const SecureNavigator({
    required this.context,
    required this.auth,
    required this.logger,
  });
  
  Future<void> navigateToSecure(
    String route, {
    Object? arguments,
    bool requireAuth = true,
  }) async {
    try {
      // Check authentication if required
      if (requireAuth) {
        if (!await auth.isAuthenticated()) {
          await logger.logAccess('Unauthorized access attempt to $route');
          await auth.setRedirectPath(route);
          await navigateTo('/login');
          return;
        }

        // Check session expiry
        if (await auth.isSessionExpired()) {
          await _handleSessionExpired();
          return;
        }

        // Check route permissions
        if (!await auth.hasPermission(route)) {
          await logger.logError('Access denied to $route');
          _showError('Access denied');
          return;
        }
      }

      // Log navigation
      await logger.logNavigation(route);

      // Navigate to route
      await navigateTo(route, arguments: arguments);

    } catch (e) {
      await logger.logError('Navigation failed', e);
      _showError('Navigation failed');
    }
  }

  Future<void> navigateTo(
    String route, {
    Object? arguments,
  }) async {
    await Navigator.pushNamed(
      context,
      route,
      arguments: arguments,
    );
  }

  Future<void> _handleSessionExpired() async {
    await logger.logError('Session expired');
    
    // Show session expired dialog
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SessionExpiredDialog(),
    );

    if (result == true) {
      await navigateTo('/login');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Example screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final logger = NavigationLogger();
    final navigator = SecureNavigator(
      context: context,
      auth: auth,
      logger: logger,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => navigator.navigateToSecure('/account'),
              child: const Text('Go to Account'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => navigator.navigateToSecure('/admin'),
              child: const Text('Go to Admin'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await auth.login();
            
            if (context.mounted) {
              final redirectPath = auth.getRedirectPath();
              if (redirectPath != null) {
                Navigator.pushReplacementNamed(context, redirectPath);
              } else {
                Navigator.pushReplacementNamed(context, '/account');
              }
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Protected Account Screen'),
      ),
    );
  }
}

class SessionExpiredDialog extends StatelessWidget {
  const SessionExpiredDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Session Expired'),
      content: const Text(
        'Your session has expired. Please log in again to continue.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Login'),
        ),
      ],
    );
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
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/account': (context) => const AccountScreen(),
      },
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
