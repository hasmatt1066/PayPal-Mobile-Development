import '../models/transaction.dart';

abstract class TransactionRepository {
  /// Fetches a list of transactions with optional filtering
  /// 
  /// [startDate] and [endDate] can be used to filter transactions by date range
  /// [category] can be used to filter transactions by category
  /// [searchQuery] can be used to search transaction descriptions
  Future<List<Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? searchQuery,
  });

  /// Fetches a single transaction by ID
  /// 
  /// Throws [TransactionNotFoundException] if transaction doesn't exist
  Future<Transaction> getTransactionById(String id);

  /// Updates transaction metadata
  /// 
  /// Returns updated transaction
  /// Throws [TransactionNotFoundException] if transaction doesn't exist
  Future<Transaction> updateTransactionMetadata(
    String id,
    Map<String, dynamic> metadata,
  );

  /// Gets transaction categories
  /// 
  /// Returns list of unique categories from all transactions
  Future<List<String>> getCategories();
}

/// Exception thrown when a transaction is not found
class TransactionNotFoundException implements Exception {
  final String message;
  const TransactionNotFoundException([this.message = 'Transaction not found']);
  
  @override
  String toString() => message;
}
