// Exercise 1: Solution - Transaction model and value objects

import 'package:intl/intl.dart';

/// Represents the status of a transaction
enum TransactionStatus {
  completed,
  pending,
  failed;
  
  String get displayName {
    switch (this) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}

/// Value object representing monetary amounts
class Money {
  final double value;
  final String currency;
  
  const Money({
    required this.value,
    this.currency = 'USD',
  }) {
    if (value.isNaN) {
      throw InvalidCurrencyException('Amount cannot be NaN');
    }
  }
  
  /// Formats the amount with currency symbol
  String get formatted => '\$${value.abs().toStringAsFixed(2)}';
  
  /// Adds two monetary values
  Money operator +(Money other) {
    if (currency != other.currency) {
      throw InvalidCurrencyException(
        'Cannot add different currencies: $currency and ${other.currency}',
      );
    }
    return Money(
      value: value + other.value,
      currency: currency,
    );
  }
  
  /// Creates a copy with a different amount
  Money copyWith({double? value, String? currency}) {
    return Money(
      value: value ?? this.value,
      currency: currency ?? this.currency,
    );
  }
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Money &&
    runtimeType == other.runtimeType &&
    value == other.value &&
    currency == other.currency;
    
  @override
  int get hashCode => value.hashCode ^ currency.hashCode;
}

/// Exception thrown when transaction data is invalid
class InvalidTransactionException implements Exception {
  final String message;
  
  const InvalidTransactionException(this.message);
  
  @override
  String toString() => 'InvalidTransactionException: $message';
}

/// Exception thrown when currency operations are invalid
class InvalidCurrencyException implements Exception {
  final String message;
  
  const InvalidCurrencyException(this.message);
  
  @override
  String toString() => 'InvalidCurrencyException: $message';
}

/// Represents a financial transaction
class Transaction {
  final String id;
  final Money amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  
  /// Creates a new transaction with validation
  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  }) {
    validateId(id);
    validateDescription(description);
    validateAmount(amount);
  }
  
  /// Validates transaction ID
  static void validateId(String id) {
    if (id.isEmpty) {
      throw InvalidTransactionException('Transaction ID cannot be empty');
    }
    if (!RegExp(r'^[A-Za-z0-9\-]+$').hasMatch(id)) {
      throw InvalidTransactionException(
        'Transaction ID can only contain letters, numbers, and hyphens',
      );
    }
  }
  
  /// Validates transaction description
  static void validateDescription(String description) {
    if (description.isEmpty) {
      throw InvalidTransactionException('Description cannot be empty');
    }
    if (description.length > 100) {
      throw InvalidTransactionException(
        'Description cannot be longer than 100 characters',
      );
    }
  }
  
  /// Validates transaction amount
  static void validateAmount(Money amount) {
    if (amount.value.abs() > 1000000) {
      throw InvalidTransactionException(
        'Transaction amount cannot exceed \$1,000,000',
      );
    }
  }
  
  /// Indicates if this is a credit (positive amount)
  bool get isCredit => amount.value > 0;
  
  /// Checks if transaction is from the last 7 days
  bool get isRecent => date.isAfter(
    DateTime.now().subtract(const Duration(days: 7)),
  );
  
  /// Checks if transaction requires approval
  bool requiresApproval() => amount.value.abs() > 10000;
  
  /// Formats the transaction date
  String get formattedDate => DateFormat.yMMMd().format(date);
  
  /// Gets the display text for the status
  String get statusText => status.displayName;
  
  /// Creates a copy with optional new values
  Transaction copyWith({
    String? id,
    Money? amount,
    String? description,
    DateTime? date,
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
  
  @override
  String toString() => 
    'Transaction(id: $id, amount: ${amount.formatted}, '
    'description: $description, date: $formattedDate, '
    'status: $statusText)';
}

void main() {
  // Example usage
  try {
    final transaction = Transaction(
      id: 'TXN-123',
      amount: Money(value: 100.50),
      description: 'Test Payment',
      date: DateTime.now(),
      status: TransactionStatus.completed,
    );
    
    print('Transaction created: $transaction');
    print('Is credit: ${transaction.isCredit}');
    print('Is recent: ${transaction.isRecent}');
    print('Requires approval: ${transaction.requiresApproval()}');
    
  } catch (e) {
    print('Error creating transaction: $e');
  }
}
