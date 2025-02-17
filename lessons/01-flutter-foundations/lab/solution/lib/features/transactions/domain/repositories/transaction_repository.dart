import '../models/transaction.dart';
import '../exceptions/transaction_exception.dart';

// Domain layer - Repository interface
abstract class TransactionRepository {
  /// Fetches a list of transactions
  /// 
  /// Throws [TransactionException] if the operation fails
  Future<List<Transaction>> getTransactions();

  /// Fetches a single transaction by ID
  /// 
  /// Throws [TransactionException] if the transaction is not found
  /// or if the operation fails
  Future<Transaction> getTransactionById(String id);

  /// Creates a new transaction
  /// 
  /// Returns the created transaction
  /// Throws [TransactionException] if the operation fails
  Future<Transaction> createTransaction(Transaction transaction);

  /// Updates an existing transaction
  /// 
  /// Returns the updated transaction
  /// Throws [TransactionException] if the transaction is not found
  /// or if the operation fails
  Future<Transaction> updateTransaction(Transaction transaction);

  /// Deletes a transaction by ID
  /// 
  /// Throws [TransactionException] if the transaction is not found
  /// or if the operation fails
  Future<void> deleteTransaction(String id);
}
