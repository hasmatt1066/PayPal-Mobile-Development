// Exercise 3: Solution - Clean Architecture Implementation

import 'dart:async';
import 'exercise1.dart';
import 'exercise2.dart';

/// Generic Result class for handling success/error states
class Result<T> {
  final T? data;
  final TransactionException? error;
  
  const Result._({this.data, this.error});
  
  bool get isSuccess => error == null;
  bool get isError => error != null;
  
  /// Creates a success result
  factory Result.success(T data) => Result._(data: data);
  
  /// Creates an error result
  factory Result.error(TransactionException error) => Result._(error: error);
  
  /// Handles both success and error cases
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(TransactionException error) onError,
  }) {
    if (isSuccess) {
      return onSuccess(data as T);
    } else {
      return onError(error!);
    }
  }
  
  /// Transforms success data
  Result<R> map<R>(R Function(T data) transform) {
    return isSuccess
        ? Result.success(transform(data as T))
        : Result.error(error!);
  }
}

/// Base class for all use cases
abstract class UseCase<Input, Output> {
  /// Executes the use case with error handling
  Future<Result<Output>> execute(Input input);
  
  /// Helper to wrap repository calls with error handling
  Future<Result<T>> safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Result.success(result);
    } on TransactionException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(
        TransactionException(
          'Unexpected error: $e',
          code: 'UNKNOWN_ERROR',
          details: e,
        ),
      );
    }
  }
}

/// Domain service for transaction business logic
abstract class TransactionDomainService {
  /// Validates a transaction
  Result<void> validateTransaction(Transaction transaction);
  
  /// Calculates transaction metrics
  Result<TransactionMetrics> calculateTransactionMetrics(
    List<Transaction> transactions,
  );
  
  /// Aggregates transaction data
  Result<TransactionAggregates> aggregateTransactionData(
    List<Transaction> transactions,
  );
}

/// Data source interface for raw data access
abstract class TransactionDataSource {
  /// Fetches raw transaction data
  Future<List<Map<String, dynamic>>> fetchTransactions();
  
  /// Fetches raw transaction by ID
  Future<Map<String, dynamic>> fetchTransactionById(String id);
  
  /// Persists raw transaction data
  Future<void> persistTransaction(Map<String, dynamic> data);
  
  /// Deletes raw transaction data
  Future<void> deleteTransaction(String id);
}

/// Presenter interface for formatting data
abstract class TransactionPresenter {
  /// Formats a transaction for display
  String formatTransaction(Transaction transaction);
  
  /// Formats an amount with proper currency
  String formatAmount(Money amount);
  
  /// Formats a date according to locale
  String formatDate(DateTime date);
  
  /// Gets localized status text
  String getStatusText(TransactionStatus status);
}

/// Use case for getting a transaction by ID
class GetTransactionUseCase extends UseCase<String, Transaction> {
  final TransactionRepository repository;
  final TransactionDomainService domainService;
  
  GetTransactionUseCase({
    required this.repository,
    required this.domainService,
  });
  
  @override
  Future<Result<Transaction>> execute(String id) async {
    // Validate input
    if (id.isEmpty) {
      return Result.error(
        InvalidTransactionDataException('Transaction ID cannot be empty'),
      );
    }
    
    // Get transaction
    return safeCall(() => repository.getTransactionById(id));
  }
}

/// Use case for saving a transaction
class SaveTransactionUseCase extends UseCase<Transaction, void> {
  final TransactionRepository repository;
  final TransactionDomainService domainService;
  
  SaveTransactionUseCase({
    required this.repository,
    required this.domainService,
  });
  
  @override
  Future<Result<void>> execute(Transaction transaction) async {
    // Validate transaction
    final validationResult = domainService.validateTransaction(transaction);
    if (validationResult.isError) {
      return Result.error(validationResult.error!);
    }
    
    // Save transaction
    return safeCall(() => repository.saveTransaction(transaction));
  }
}

/// Clean architecture implementation of repository
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDataSource dataSource;
  final TransactionDomainService domainService;
  final TransactionPresenter presenter;
  
  TransactionRepositoryImpl({
    required this.dataSource,
    required this.domainService,
    required this.presenter,
  });
  
  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      // Get raw data
      final data = await dataSource.fetchTransactions();
      
      // Map to domain models
      final transactions = data.map((d) => _mapToTransaction(d)).toList();
      
      // Calculate metrics
      final metricsResult = domainService.calculateTransactionMetrics(
        transactions,
      );
      
      if (metricsResult.isError) {
        throw metricsResult.error!;
      }
      
      return transactions;
      
    } catch (e) {
      throw TransactionException(
        'Failed to get transactions',
        code: 'FETCH_ERROR',
        details: e,
      );
    }
  }
  
  @override
  Future<Transaction> getTransactionById(String id) async {
    try {
      // Get raw data
      final data = await dataSource.fetchTransactionById(id);
      
      // Map to domain model
      return _mapToTransaction(data);
      
    } catch (e) {
      throw TransactionNotFoundException(id);
    }
  }
  
  // Helper to map raw data to domain model
  Transaction _mapToTransaction(Map<String, dynamic> data) {
    return Transaction(
      id: data['id'] as String,
      amount: Money(value: data['amount'] as double),
      description: data['description'] as String,
      date: DateTime.parse(data['date'] as String),
      status: TransactionStatus.values.firstWhere(
        (s) => s.toString() == data['status'],
      ),
    );
  }
  
  // Implement other repository methods similarly...
}

/// Example domain models
class TransactionMetrics {
  final double totalCredits;
  final double totalDebits;
  final int transactionCount;
  
  TransactionMetrics({
    required this.totalCredits,
    required this.totalDebits,
    required this.transactionCount,
  });
}

class TransactionAggregates {
  final Map<String, double> byCategory;
  final Map<TransactionStatus, int> byStatus;
  
  TransactionAggregates({
    required this.byCategory,
    required this.byStatus,
  });
}

void main() async {
  // Example usage of clean architecture
  final dataSource = MockTransactionDataSource();
  final domainService = TransactionDomainServiceImpl();
  final presenter = TransactionPresenterImpl();
  
  final repository = TransactionRepositoryImpl(
    dataSource: dataSource,
    domainService: domainService,
    presenter: presenter,
  );
  
  final getTransaction = GetTransactionUseCase(
    repository: repository,
    domainService: domainService,
  );
  
  // Use the Result class for error handling
  final result = await getTransaction.execute('TXN-1');
  
  result.fold(
    onSuccess: (transaction) {
      print('Transaction found: ${presenter.formatTransaction(transaction)}');
    },
    onError: (error) {
      print('Error: $error');
    },
  );
}

/// Mock implementations for example
class MockTransactionDataSource implements TransactionDataSource {
  // Implementation...
}

class TransactionDomainServiceImpl implements TransactionDomainService {
  // Implementation...
}

class TransactionPresenterImpl implements TransactionPresenter {
  // Implementation...
}
