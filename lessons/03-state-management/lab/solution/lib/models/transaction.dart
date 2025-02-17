// Transaction model with proper equality and hash code
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == amount &&
          description == description &&
          date == date &&
          status == status;

  @override
  int get hashCode =>
      id.hashCode ^
      amount.hashCode ^
      description.hashCode ^
      date.hashCode ^
      status.hashCode;

  // Helper method for validation
  bool isValid() {
    return id.isNotEmpty &&
        amount > 0 &&
        description.isNotEmpty &&
        date.isBefore(DateTime.now());
  }
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}
