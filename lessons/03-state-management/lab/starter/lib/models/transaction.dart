// Basic transaction model
class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;

  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}
