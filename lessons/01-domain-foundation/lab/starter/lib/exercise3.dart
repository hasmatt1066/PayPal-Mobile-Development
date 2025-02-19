// Exercise 3: Implement Clean Architecture Structure

// Import previous exercises
import 'exercise1.dart';
import 'exercise2.dart';

// TODO: Implement Result class for error handling
class Result<T> {
  // TODO: Add fields:
  // - data (T?)
  // - error (TransactionException?)
  // - isSuccess (bool)
  
  // TODO: Implement constructors:
  // - success constructor
  // - error constructor
  
  // TODO: Add helper methods:
  // - fold() for handling both success and error cases
  // - map() for transforming success data
}

// TODO: Implement UseCase abstract class
abstract class UseCase<Input, Output> {
  // TODO: Add execute method that returns Result<Output>
}

// TODO: Implement domain layer interfaces
abstract class TransactionDomainService {
  // TODO: Add methods:
  // - validateTransaction()
  // - calculateTransactionMetrics()
  // - aggregateTransactionData()
}

// TODO: Implement data layer interfaces
abstract class TransactionDataSource {
  // TODO: Add methods:
  // - fetchTransactions()
  // - fetchTransactionById()
  // - persistTransaction()
  // - deleteTransaction()
}

// TODO: Implement presentation layer interfaces
abstract class TransactionPresenter {
  // TODO: Add methods:
  // - formatTransaction()
  // - formatAmount()
  // - formatDate()
  // - getStatusText()
}

// TODO: Implement use cases
class GetTransactionUseCase extends UseCase<String, Transaction> {
  // TODO: Implement execute method:
  // 1. Validate input
  // 2. Call repository
  // 3. Handle errors
  // 4. Return result
}

class SaveTransactionUseCase extends UseCase<Transaction, void> {
  // TODO: Implement execute method:
  // 1. Validate transaction
  // 2. Call repository
  // 3. Handle errors
  // 4. Return result
}

// TODO: Implement repository with clean architecture
class TransactionRepositoryImpl implements TransactionRepository {
  // TODO: Add fields:
  // - dataSource
  // - domainService
  // - presenter
  
  // TODO: Implement repository methods using clean architecture:
  // 1. Call data source
  // 2. Map to domain models
  // 3. Apply domain logic
  // 4. Format for presentation
  // 5. Handle errors
}

void main() {
  // TODO: Test your implementation:
  // 1. Create repository with all dependencies
  // 2. Create use cases
  // 3. Test error handling with Result class
  // 4. Verify clean architecture flow
  
  print('Implement Clean Architecture to pass all tests!');
}
