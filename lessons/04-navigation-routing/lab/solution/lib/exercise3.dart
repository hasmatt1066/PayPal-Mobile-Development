import 'package:flutter/material.dart';
import 'services/auth_service.dart';

// Exercise 3: Deep Link Security
// Implementation of secure deep link handling

class SecureDeepLinkHandler {
  final AuthService auth;
  final NavigationLogger logger;
  
  const SecureDeepLinkHandler({
    required this.auth,
    required this.logger,
  });
  
  Future<bool> handleLink(Uri uri) async {
    try {
      // Validate URI structure
      if (!isValidDeepLink(uri)) {
        await logger.logError('Invalid deep link format: ${uri.toString()}');
        return false;
      }

      // Sanitize path and parameters
      final sanitizedPath = sanitizePath(uri.path);
      final sanitizedParams = sanitizeParams(uri.queryParameters);

      // Log deep link attempt
      await logger.logNavigation(
        'Deep link: $sanitizedPath - Params: $sanitizedParams',
      );

      // Check authentication for protected routes
      if (requiresAuth(sanitizedPath)) {
        if (!await auth.isAuthenticated()) {
          await auth.setRedirectPath(sanitizedPath);
          return false;
        }

        if (await auth.isSessionExpired()) {
          return false;
        }

        if (!await auth.hasPermission(sanitizedPath)) {
          await logger.logError('Access denied to $sanitizedPath');
          return false;
        }
      }

      return true;

    } catch (e) {
      await logger.logError('Deep link handling failed', e);
      return false;
    }
  }
  
  bool isValidDeepLink(Uri uri) {
    // Validate scheme
    if (uri.scheme != 'payapp') {
      return false;
    }

    // Validate host
    if (!['payment', 'transfer'].contains(uri.host)) {
      return false;
    }

    // Validate path format
    if (!RegExp(r'^/[a-zA-Z0-9-_]+$').hasMatch(uri.path)) {
      return false;
    }

    // Validate required parameters
    switch (uri.host) {
      case 'payment':
        return uri.queryParameters.containsKey('id');
      case 'transfer':
        return uri.queryParameters.containsKey('accountId');
      default:
        return false;
    }
  }
  
  String sanitizePath(String path) {
    // Remove any special characters
    return path.replaceAll(RegExp(r'[^a-zA-Z0-9-_/]'), '');
  }
  
  Map<String, String> sanitizeParams(Map<String, String> params) {
    final sanitized = <String, String>{};
    
    for (final entry in params.entries) {
      // Remove any special characters from keys and values
      final key = entry.key.replaceAll(RegExp(r'[^a-zA-Z0-9-_]'), '');
      final value = entry.value.replaceAll(RegExp(r'[^a-zA-Z0-9-_.]'), '');
      
      if (key.isNotEmpty && value.isNotEmpty) {
        sanitized[key] = value;
      }
    }
    
    return sanitized;
  }

  bool requiresAuth(String path) {
    return path.startsWith('/payment/') || path.startsWith('/transfer/');
  }
}

// Example payment screen
class PaymentScreen extends StatelessWidget {
  final String paymentId;
  
  const PaymentScreen({
    required this.paymentId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Payment ID: $paymentId'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example transfer screen
class TransferScreen extends StatelessWidget {
  final String accountId;
  final double? amount;
  
  const TransferScreen({
    required this.accountId,
    this.amount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Money'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Account ID: $accountId'),
            if (amount != null) ...[
              const SizedBox(height: 8),
              Text('Amount: \$${amount!.toStringAsFixed(2)}'),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example deep link configuration
class DeepLinkConfig {
  static final auth = AuthService();
  static final logger = NavigationLogger();
  static final deepLinkHandler = SecureDeepLinkHandler(
    auth: auth,
    logger: logger,
  );

  static Future<Widget> handleDeepLink(Uri uri) async {
    try {
      final canAccess = await deepLinkHandler.handleLink(uri);
      if (!canAccess) {
        return const DeepLinkErrorScreen(
          message: 'Access denied',
        );
      }

      final sanitizedPath = deepLinkHandler.sanitizePath(uri.path);
      final sanitizedParams = deepLinkHandler.sanitizeParams(uri.queryParameters);

      switch (uri.host) {
        case 'payment':
          return PaymentScreen(
            paymentId: sanitizedParams['id']!,
          );
        case 'transfer':
          return TransferScreen(
            accountId: sanitizedParams['accountId']!,
            amount: double.tryParse(sanitizedParams['amount'] ?? ''),
          );
        default:
          return const DeepLinkErrorScreen(
            message: 'Invalid deep link',
          );
      }

    } catch (e) {
      await logger.logError('Deep link handling failed', e);
      return const DeepLinkErrorScreen(
        message: 'Failed to handle deep link',
      );
    }
  }

  static Route<dynamic> generateRoute(Uri uri) {
    return MaterialPageRoute(
      builder: (context) => FutureBuilder<Widget>(
        future: handleDeepLink(uri),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return DeepLinkErrorScreen(
              message: snapshot.error.toString(),
            );
          }

          return snapshot.data ?? const DeepLinkErrorScreen(
            message: 'Invalid deep link',
          );
        },
      ),
    );
  }
}

// Example deep link error screen
class DeepLinkErrorScreen extends StatelessWidget {
  final String message;

  const DeepLinkErrorScreen({
    required this.message,
    Key? key,
  }) : super(key: key);

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
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deep Link Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final uri = Uri.parse('payapp://payment/123?id=PAYMENT123');
                Navigator.push(
                  context,
                  DeepLinkConfig.generateRoute(uri),
                );
              },
              child: const Text('Test Payment Deep Link'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final uri = Uri.parse(
                  'payapp://transfer/456?accountId=ACC456&amount=100.50',
                );
                Navigator.push(
                  context,
                  DeepLinkConfig.generateRoute(uri),
                );
              },
              child: const Text('Test Transfer Deep Link'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final uri = Uri.parse('payapp://invalid/link');
                Navigator.push(
                  context,
                  DeepLinkConfig.generateRoute(uri),
                );
              },
              child: const Text('Test Invalid Deep Link'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main app widget for testing
class Exercise3App extends StatelessWidget {
  const Exercise3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Lab - Exercise 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

void main() {
  runApp(const Exercise3App());
}
