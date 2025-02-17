import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/exceptions/transaction_exception.dart';
import '../datasources/transaction_api.dart';
import '../mappers/transaction_mapper.dart';

// Data layer - Repository implementation
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApi _api;

  TransactionRepositoryImpl({
    required TransactionApi api,
  }) : _api = api;

  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      final jsonList = await _api.getTransactions();
      return TransactionMapper.fromJsonList(jsonList);
    } catch (e) {
      if (e is TransactionException) {
        rethrow;
      }
      throw TransactionException.networkError(e);
    }
  }

  @override
  Future<Transaction> getTransactionById(String id) async {
    try {
      final json = await _api.getTransactionById(id);
      return TransactionMapper.fromJson(json);
    } catch (e) {
      if (e is TransactionException) {
        rethrow;
      }
      throw TransactionException.networkError(e);
    }
  }

  @override
  Future<Transaction> createTransaction(Transaction transaction) async {
    try {
      final json = TransactionMapper.toJson(transaction);
      final responseJson = await _api.createTransaction(json);
      return TransactionMapper.fromJson(responseJson);
    } catch (e) {
      if (e is TransactionException) {
        rethrow;
      }
      throw TransactionException.networkError(e);
    }
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    // Implementation would be similar to createTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    // Implementation would handle deletion through API
    throw UnimplementedError();
  }
}
