// Logger implementations
class BiometricLogger {
  final List<String> _logs = [];

  Future<void> logAuthentication(
    String action,
    bool success,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Authentication $action: ${success ? 'Success' : 'Failed'}';
    print(log);
    _logs.add(log);
  }

  Future<void> logError(
    String message,
    String action,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Error in $action: $message';
    print(log);
    _logs.add(log);
  }

  List<String> getLogs() => List.unmodifiable(_logs);
}

class StorageLogger {
  final List<String> _logs = [];

  Future<void> logStorage(
    String operation,
    String key,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Storage $operation: $key';
    print(log);
    _logs.add(log);
  }

  Future<void> logError(
    String message,
    String key,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Storage error for $key: $message';
    print(log);
    _logs.add(log);
  }

  List<String> getLogs() => List.unmodifiable(_logs);
}

class NotificationLogger {
  final List<String> _logs = [];

  Future<void> logToken(String? token) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] FCM Token: ${token ?? 'null'}';
    print(log);
    _logs.add(log);
  }

  Future<void> logNotification(
    String type,
    String messageId,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Notification $type: $messageId';
    print(log);
    _logs.add(log);
  }

  Future<void> logError(
    String message, [
    dynamic error,
  ]) async {
    final timestamp = DateTime.now().toIso8601String();
    final log = '[$timestamp] Notification error: $message${error != null ? ' - $error' : ''}';
    print(log);
    _logs.add(log);
  }

  List<String> getLogs() => List.unmodifiable(_logs);
}
