// Domain layer - Custom exception
class TransactionException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const TransactionException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    String result = 'TransactionException: $message';
    if (code != null) {
      result += ' (Code: $code)';
    }
    if (originalError != null) {
      result += '\nOriginal error: $originalError';
    }
    return result;
  }

  // Common error instances
  static TransactionException notFound(String id) => TransactionException(
        'Transaction not found: $id',
        code: 'TRANSACTION_NOT_FOUND',
      );

  static TransactionException invalidAmount() => const TransactionException(
        'Invalid transaction amount',
        code: 'INVALID_AMOUNT',
      );

  static TransactionException networkError([dynamic error]) => TransactionException(
        'Network error occurred',
        code: 'NETWORK_ERROR',
        originalError: error,
      );

  static TransactionException unauthorized() => const TransactionException(
        'Unauthorized access',
        code: 'UNAUTHORIZED',
      );
}
