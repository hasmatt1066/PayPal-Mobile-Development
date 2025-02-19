import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // TODO: Implement route generation and protection
    // Use this method to:
    // 1. Parse route names and parameters
    // 2. Check authentication status
    // 3. Apply navigation guards
    // 4. Handle deep links
    // 5. Log navigation events
    
    switch (settings.name) {
      case '/':
        // TODO: Return route for TransactionListScreen
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Implement Transaction List Screen'),
            ),
          ),
        );
        
      case '/transaction':
        // TODO: Parse transaction ID from arguments
        // TODO: Return route for TransactionDetailsScreen
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Implement Transaction Details Screen'),
            ),
          ),
        );
        
      case '/categories':
        // TODO: Return route for CategoriesScreen
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Implement Categories Screen'),
            ),
          ),
        );
        
      default:
        // Handle unknown routes
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}

/// Route names used throughout the app
class Routes {
  static const String home = '/';
  static const String transaction = '/transaction';
  static const String categories = '/categories';
  
  /// Helper to generate transaction details route
  static String transactionDetails(String id) => '$transaction?id=$id';
}
