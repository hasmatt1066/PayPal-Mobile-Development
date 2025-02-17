import '../../domain/models/transaction.dart';

// Data layer - Mapper for converting between API and domain models
class TransactionMapper {
  // Maps API response to domain model
  static Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      status: _parseStatus(json['status'] as String),
    );
  }

  // Maps domain model to API request format
  static Map<String, dynamic> toJson(Transaction transaction) {
    return {
      'id': transaction.id,
      'amount': transaction.amount,
      'description': transaction.description,
      'date': transaction.date.toIso8601String(),
      'status': _formatStatus(transaction.status),
    };
  }

  // Helper method to parse status from string
  static TransactionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return TransactionStatus.completed;
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      default:
        throw ArgumentError('Invalid transaction status: $status');
    }
  }

  // Helper method to format status to string
  static String _formatStatus(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'completed';
      case TransactionStatus.pending:
        return 'pending';
      case TransactionStatus.failed:
        return 'failed';
    }
  }

  // Maps a list of JSON objects to domain models
  static List<Transaction> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => fromJson(json)).toList();
  }

  // Maps a list of domain models to JSON objects
  static List<Map<String, dynamic>> toJsonList(List<Transaction> transactions) {
    return transactions.map((transaction) => toJson(transaction)).toList();
  }
}
