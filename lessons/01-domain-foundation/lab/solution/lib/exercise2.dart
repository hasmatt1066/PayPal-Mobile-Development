// Exercise 2: Solution - Repository interface and error handling

import 'dart:async';
import 'exercise1.dart';

/// Base exception class for transaction-related errors
abstract class TransactionException implements Exception {
  final String message;
  final String? code;
  final dynamic details;
  
  const TransactionException(
    this.message, {
    this.code,
    this.details,
  });
  
  @override
  String toString() => 'TransactionException: $message${
    code != null ? ' ($code)' : ''
  }';
}

/// Exception thrown when a transaction is not found
class TransactionNotFoundException extends TransactionException {
  TransactionNotFoundException(String id)
      : super(
          'Transaction not found: $id',
          code: 'NOT_FOUND',
        );
}

/// Exception thrown when transaction data is invalid
class InvalidTransactionDataException extends TransactionException {
  InvalidTransactionDataException(String message, [dynamic details])
      : super(
          message,
          code: 'INVALID_DATA',
          details: details,
        );
}

/// Exception thrown when transaction validation fails
class TransactionValidationException extends TransactionException {
  TransactionValidationException(String message, [dynamic details])
      : super(
          message,
          code: 'VALIDATION_ERROR',
          details: details,
        );
}

/// Repository interface for transaction data access
abstract class TransactionRepository {
  /// Fetches all transactions
  Future<List<Transaction>> getTransactions();
  
  /// Fetches a transaction by ID
  /// 
  /// Throws [TransactionNotFoundException] if not found
  Future<Transaction> getTransactionById(String id);
  
  /// Fetches transactions within a date range
  Future<List<Transaction>> getTransactionsByDate(
    DateTime start,
    DateTime end,
  );
  
  /// Saves a new transaction
  /// 
  /// Throws [InvalidTransactionDataException] if data is invalid
  Future<void> saveTransaction(Transaction transaction);
  
  /// Updates an existing transaction
  /// 
  /// Throws [TransactionNotFoundException] if not found
  /// Throws [InvalidTransactionDataException] if data is invalid
  Future<void> updateTransaction(Transaction transaction);
  
  /// Deletes a transaction by ID
  /// 
  /// Throws [TransactionNotFoundException] if not found
  Future<void> deleteTransaction(String id);
}

/// Mock implementation of TransactionRepository for testing
class MockTransactionRepository implements TransactionRepository {
  final List<Transaction> _transactions = [];
  final bool _errorSimulation;
  
  MockTransactionRepository({bool simulateErrors = false})
      : _errorSimulation = simulateErrors;
  
  @override
  Future<List<Transaction>> getTransactions() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_errorSimulation) {
      throw InvalidTransactionDataException('Error fetching transactions');
    }
    
    return List.unmodifiable(_transactions);
  }
  
  @override
  Future<Transaction> getTransactionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_errorSimulation) {
      throw TransactionNotFoundException(id);
    }
    
    final transaction = _transactions.firstWhere(
      (t) => t.id == id,
      orElse: () => throw TransactionNotFoundException(id),
    );
    
    return transaction;
  }
  
  @override
  Future<List<Transaction>> getTransactionsByDate(
    DateTime start,
    DateTime end,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_errorSimulation) {
      throw InvalidTransactionDataException('Error filtering transactions');
    }
    
    return _transactions.where((t) {
      return t.date.isAfter(start) && t.date.isBefore(end);
    }).toList();
  }
  
  @override
  Future<void> saveTransaction(Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_errorSimulation) {
      throw InvalidTransactionDataException('Error saving transaction');
    }
    
    // Validate transaction
    try {
      Transaction.validateId(transaction.id);
      Transaction.validateDescription(transaction.description);
      Transaction.validateAmount(transaction.amount);
    } catch (e) {
      throw InvalidTransactionDataException('Invalid transaction data', e);
    }
    
    // Check for duplicate ID
    if (_transactions.any((t) => t.id == transaction.id)) {
      throw InvalidTransactionDataException(
        'Transaction with ID ${transaction.id} already exists',
      );
    }
    
    _transactions.add(transaction);
  }
  
  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (_errorSimulation) {
      throw InvalidTransactionDataException('Error updating transaction');
    }
    
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index == -1) {
      throw TransactionNotFoundException(transaction.id);
    }
    
    // Validate transaction
    try {
      Transaction.validateId(transaction.id);
      Transaction.validateDescription(transaction.description);
      Transaction.validateAmount(transaction.amount);
    } catch (e) {
      throw InvalidTransactionDataException('Invalid transaction data', e);
    }
    
    _transactions[index] = transaction;
  }
  
  @override
  Future<void> deleteTransaction(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (_errorSimulation) {
      throw TransactionNotFoundException(id);
    }
    
    final removed = _transactions.removeWhere((t) => t.id == id);
    if (!removed) {
      throw TransactionNotFoundException(id);
    }
  }
}

void main() async {
  // Example usage
  final repository = MockTransactionRepository();
  
  try {
    // Create test transactions
    final transaction1 = Transaction(
      id: 'TXN-1',
      amount: Money(value: 100.50),
      description: 'Test Payment 1',
      date: DateTime.now(),
      status: TransactionStatus.completed,
    );
    
    final transaction2 = Transaction(
      id: 'TXN-2',
      amount: Money(value: -50.25),
      description: 'Test Payment 2',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.pending,
    );
    
    // Test CRUD operations
    await repository.saveTransaction(transaction1);
    await repository.saveTransaction(transaction2);
    
    final transactions = await repository.getTransactions();
    print('All transactions: $transactions');
    
    final found = await repository.getTransactionById('TXN-1');
    print('Found transaction: $found');
    
    await repository.deleteTransaction('TXN-2');
    print('Transaction deleted');
    
    // Test error handling
    try {
      await repository.getTransactionById('invalid-id');
    } catch (e) {
      print('Expected error: $e');
    }
    
  } catch (e) {
    print('Unexpected error: $e');
  }
}
