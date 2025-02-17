import 'package:flutter/material.dart';
import 'services/auth_service.dart';

// Exercise 2: Route Protection
// Implementation of route guards and authorization

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
    try {
      // Log access attempt
      await logger.logAccess(route);

      // Check authentication
      if (!await auth.isAuthenticated()) {
        await _handleUnauthorized(context, route);
        return false;
      }

      // Check session expiry
      if (await auth.isSessionExpired()) {
        await _handleSessionExpired(context);
        return false;
      }

      // Check route permissions
      if (!await auth.hasPermission(route)) {
        await _handleForbidden(context);
        return false;
      }

      return true;

    } catch (e) {
      await logger.logError('Guard check failed', e);
      _showError(context, 'Access check failed');
      return false;
    }
  }

  Future<void> _handleUnauthorized(
    BuildContext context,
    String route,
  ) async {
    await logger.logError('Unauthorized access to $route');
    await auth.setRedirectPath(route);
    
    if (context.mounted) {
      await Navigator.pushNamed(context, '/login');
    }
  }

  Future<void> _handleSessionExpired(
    BuildContext context,
  ) async {
    await logger.logError('Session expired');
    
    if (context.mounted) {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const SessionExpiredDialog(),
      );

      if (result == true && context.mounted) {
        await Navigator.pushNamed(context, '/login');
      }
    }
  }

  Future<void> _handleForbidden(
    BuildContext context,
  ) async {
    await logger.logError('Access forbidden');
    _showError(context, 'Access denied');
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Example protected route
class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Protected Account Screen'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Go to Settings'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/admin'),
              child: const Text('Go to Admin'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Protected Settings Screen'),
      ),
    );
  }
}

// Example admin screen
class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
      ),
      body: const Center(
        child: Text('Restricted Admin Screen'),
      ),
    );
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => FutureBuilder<bool>(
        future: _checkAccess(context, settings.name ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.data == true) {
            return _buildRoute(settings.name ?? '') ?? const RouteErrorScreen();
          }

          return const RouteErrorScreen();
        },
      ),
    );
  }

  static Future<bool> _checkAccess(BuildContext context, String route) async {
    if (route == '/login' || route == '/') return true;
    return authGuard.canActivate(context, route);
  }

  static Widget? _buildRoute(String route) {
    switch (route) {
      case '/':
        return const HomeScreen();
      case '/login':
        return const LoginScreen();
      case '/account':
        return const AccountScreen();
      case '/settings':
        return const SettingsScreen();
      case '/admin':
        return const AdminScreen();
      default:
        return null;
    }
  }
}

// Example home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/account'),
              child: const Text('Go to Account'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Go to Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example login screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AppRouter.auth.login();
            
            if (context.mounted) {
              final redirectPath = AppRouter.auth.getRedirectPath();
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

// Example session expired dialog
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

// Example route error screen
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Route access denied'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              ),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
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
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
