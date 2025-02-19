// Exercise 2: Implement the Repository interface and error handling

// Import the Transaction model from exercise1.dart
import 'exercise1.dart';

// TODO: Implement base exception class
abstract class TransactionException implements Exception {
  // TODO: Add fields:
  // - message (String)
  // - code (String?)
  // - details (dynamic)
  
  // TODO: Implement toString method
}

// TODO: Implement specific exceptions
class TransactionNotFoundException extends TransactionException {
  // TODO: Implement constructor that sets appropriate message and code
}

class InvalidTransactionDataException extends TransactionException {
  // TODO: Implement constructor that sets appropriate message and code
}

class TransactionValidationException extends TransactionException {
  // TODO: Implement constructor that sets appropriate message and code
}

// TODO: Implement repository interface
abstract class TransactionRepository {
  // TODO: Add methods:
  // - getTransactions()
  // - getTransactionById(String id)
  // - getTransactionsByDate(DateTime start, DateTime end)
  // - saveTransaction(Transaction transaction)
  // - updateTransaction(Transaction transaction)
  // - deleteTransaction(String id)
  
  // All methods should:
  // 1. Be asynchronous (Future)
  // 2. Include proper error handling
  // 3. Have clear return types
  // 4. Document parameters
}

// TODO: Implement mock repository for testing
class MockTransactionRepository implements TransactionRepository {
  // TODO: Add fields:
  // - _transactions (List<Transaction>)
  // - _errorSimulation (bool)
  
  // TODO: Implement all interface methods
  // - Add artificial delay for async simulation
  // - Include error simulation logic
  // - Maintain in-memory transaction list
  // - Implement CRUD operations
}

void main() {
  // TODO: Test your implementation:
  // 1. Create mock repository
  // 2. Add test transactions
  // 3. Test CRUD operations
  // 4. Verify error handling
  // 5. Test date filtering
  
  print('Implement the Repository interface to pass all tests!');
}
