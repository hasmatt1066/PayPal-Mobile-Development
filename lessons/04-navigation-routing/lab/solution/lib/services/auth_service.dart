import 'dart:async';

// Auth service implementation
class AuthService {
  bool _authenticated = false;
  String? _redirectPath;
  DateTime? _lastActivity;
  static const sessionTimeout = Duration(minutes: 30);
  
  Future<bool> isAuthenticated() async {
    if (_authenticated) {
      _updateLastActivity();
    }
    return _authenticated;
  }
  
  Future<void> setRedirectPath(String path) async {
    _redirectPath = path;
  }

  String? getRedirectPath() {
    final path = _redirectPath;
    _redirectPath = null;
    return path;
  }

  Future<bool> isSessionExpired() async {
    if (!_authenticated || _lastActivity == null) {
      return false;
    }
    
    final now = DateTime.now();
    return now.difference(_lastActivity!) > sessionTimeout;
  }

  Future<bool> hasPermission(String route) async {
    if (!_authenticated) return false;
    
    // Simulate permission check based on route
    switch (route) {
      case '/account':
        return true;
      case '/settings':
        return true;
      case '/admin':
        return false; // Example of restricted route
      default:
        return true;
    }
  }

  Future<void> login() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _authenticated = true;
    _updateLastActivity();
  }

  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    _authenticated = false;
    _lastActivity = null;
    _redirectPath = null;
  }

  void _updateLastActivity() {
    _lastActivity = DateTime.now();
  }
}

// Navigation logger implementation
class NavigationLogger {
  final List<String> _logs = [];

  Future<void> logNavigation(String route) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Navigating to: $route';
    print(log);
    _logs.add(log);
  }

  Future<void> logError(String message, [dynamic error]) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Error: $message${error != null ? ' - $error' : ''}';
    print(log);
    _logs.add(log);
  }

  Future<void> logAccess(String route) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Access attempt: $route';
    print(log);
    _logs.add(log);
  }

  List<String> getLogs() => List.unmodifiable(_logs);
}
