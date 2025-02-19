// Exercise 1: Implement the Transaction model and related value objects

// TODO: Implement TransactionStatus enum
enum TransactionStatus {
  // Define status types:
  // - completed
  // - pending
  // - failed
}

// TODO: Implement Money value object
class Money {
  // TODO: Add fields:
  // - value (double)
  // - currency (String, default to USD)
  
  // TODO: Implement constructor with validation
  
  // TODO: Add formatting method
  
  // TODO: Implement addition operator
  
  // TODO: Add currency validation
}

// TODO: Implement custom exceptions
class InvalidTransactionException implements Exception {
  // TODO: Add message field and constructor
}

class InvalidCurrencyException implements Exception {
  // TODO: Add message field and constructor
}

// TODO: Implement Transaction model
class Transaction {
  // TODO: Add required fields:
  // - id (String)
  // - amount (Money)
  // - description (String)
  // - date (DateTime)
  // - status (TransactionStatus)
  
  // TODO: Implement constructor with validation
  
  // TODO: Add business logic methods:
  // - isCredit
  // - isRecent
  // - requiresApproval
  
  // TODO: Add helper methods:
  // - formattedDate
  // - statusText
  
  // TODO: Implement validation methods:
  // - validateId
  // - validateDescription
  // - validateAmount
}

void main() {
  // TODO: Test your implementation:
  // 1. Create a transaction
  // 2. Test validation
  // 3. Check formatting
  // 4. Verify business logic
  
  print('Implement the Transaction model to pass all tests!');
}
