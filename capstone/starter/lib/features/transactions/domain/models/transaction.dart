class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  final String? merchantName;
  final String? category;
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
    this.merchantName,
    this.category,
    this.metadata,
  });

  // Helper method to check if transaction is credit
  bool get isCredit => amount > 0;

  // Helper method to format amount with currency
  String get formattedAmount {
    final prefix = isCredit ? '+' : '-';
    return '$prefix\$${amount.abs().toStringAsFixed(2)}';
  }

  // Helper method to get status color
  String get statusText {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}
