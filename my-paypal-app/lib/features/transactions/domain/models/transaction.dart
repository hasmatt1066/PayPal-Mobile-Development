// Base transaction model that will be enhanced throughout the week

class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  
  // TODO: Day 2 - Add additional fields for transaction details
  // final String? merchantName;
  // final String? category;
  // final Map<String, dynamic>? metadata;
  
  // TODO: Day 3 - Add fields for state management
  // final bool isPending;
  // final List<StatusUpdate>? statusUpdates;
  
  // TODO: Day 4 - Add fields for deep linking
  // final String? deepLink;
  // final Map<String, dynamic>? routeParams;

  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });

  // TODO: Day 1 - Implement helper methods
  bool get isCredit => amount > 0;
  
  String get formattedAmount {
    final prefix = isCredit ? '+' : '-';
    return '$prefix\$${amount.abs().toStringAsFixed(2)}';
  }

  // TODO: Day 2 - Add timeline methods
  // List<StatusUpdate> getTimeline() { ... }
  
  // TODO: Day 3 - Add state helper methods
  // bool canUpdate() { ... }
  // bool requiresAuthentication() { ... }
  
  // TODO: Day 4 - Add navigation helpers
  // String toDeepLink() { ... }
  // Map<String, dynamic> toRouteParams() { ... }
}

enum TransactionStatus {
  completed,
  pending,
  failed;
  
  // TODO: Day 1 - Add status helper methods
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
  
  // TODO: Day 2 - Add color helpers
  // Color get color { ... }
  
  // TODO: Day 3 - Add state helpers
  // bool get canModify { ... }
  // bool get requiresAction { ... }
}

// TODO: Day 2 - Implement StatusUpdate class
// class StatusUpdate {
//   final DateTime timestamp;
//   final String status;
//   final String? description;
//   
//   const StatusUpdate({
//     required this.timestamp,
//     required this.status,
//     this.description,
//   });
// }
