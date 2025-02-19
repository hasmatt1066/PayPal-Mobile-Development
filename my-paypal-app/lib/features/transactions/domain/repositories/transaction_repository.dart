import '../models/transaction.dart';

// Repository interface that will grow throughout the week
abstract class TransactionRepository {
  // TODO: Day 1 - Basic transaction fetching
  Future<List<Transaction>> getTransactions();
  Future<Transaction> getTransactionById(String id);
  
  // TODO: Day 2 - Add filtering capabilities
  // Future<List<Transaction>> getTransactionsByDate(DateTime start, DateTime end);
  // Future<List<Transaction>> getTransactionsByCategory(String category);
  // Future<List<String>> getCategories();
  
  // TODO: Day 3 - Add state management methods
  // Future<void> updateTransaction(Transaction transaction);
  // Future<void> updateTransactionStatus(String id, TransactionStatus status);
  // Future<void> addStatusUpdate(String id, StatusUpdate update);
  
  // TODO: Day 4 - Add methods for deep linking
  // Future<Transaction> getTransactionByDeepLink(String deepLink);
  // Future<List<Transaction>> searchTransactions(String query);
}

// Base exception class for transaction-related errors
class TransactionException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const TransactionException(
    this.message, {
    this.code,
    this.details,
  });

  @override
  String toString() => 'TransactionException: $message${code != null ? ' ($code)' : ''}';
}

// TODO: Day 1 - Implement specific exceptions
class TransactionNotFoundException extends TransactionException {
  const TransactionNotFoundException(String id)
      : super('Transaction not found: $id', code: 'NOT_FOUND');
}

// TODO: Day 2 - Add validation exceptions
// class InvalidDateRangeException extends TransactionException { ... }
// class InvalidCategoryException extends TransactionException { ... }

// TODO: Day 3 - Add state-related exceptions
// class TransactionUpdateException extends TransactionException { ... }
// class InvalidStatusTransitionException extends TransactionException { ... }

// TODO: Day 4 - Add navigation-related exceptions
// class InvalidDeepLinkException extends TransactionException { ... }
// class UnauthorizedAccessException extends TransactionException { ... }
