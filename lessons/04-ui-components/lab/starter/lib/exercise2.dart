// Exercise 2: Implement the Transaction Details Screen

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Import from previous exercises
import '../../../02-state-management/lab/solution/lib/exercise1.dart';
import '../../../02-state-management/lab/solution/lib/exercise2.dart';
import 'exercise1.dart';

// TODO: Implement TransactionDetailsScreen
class TransactionDetailsScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailsScreen({
    required this.transactionId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Watch transaction state
    // final state = ref.watch(transactionProvider);
    // final transaction = state.transactions.firstWhere(
    //   (t) => t.id == transactionId,
    //   orElse: () => throw Exception('Transaction not found'),
    // );

    return Scaffold(
      appBar: AppBar(
        // TODO: Implement app bar with back button
        title: const Text('Transaction Details'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    // TODO: Handle loading state
    // if (state.loading) {
    //   return const LoadingIndicator();
    // }

    // TODO: Handle error state
    // if (state.error != null) {
    //   return ErrorDisplay(
    //     error: state.error!,
    //     onRetry: () => state.refreshTransactions(),
    //   );
    // }

    // TODO: Implement transaction details
    return const Center(
      child: Text('Implement the transaction details screen'),
    );
  }
}

// TODO: Implement TransactionTimeline
class TransactionTimeline extends StatelessWidget {
  final Transaction transaction;

  const TransactionTimeline({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement timeline UI
    return const Placeholder();
  }
}

// TODO: Implement TransactionActions
class TransactionActions extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onUpdate;

  const TransactionActions({
    required this.transaction,
    required this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement action buttons
    return const Placeholder();
  }
}

// TODO: Implement TransactionStatusBadge
class TransactionStatusBadge extends StatelessWidget {
  final TransactionStatus status;

  const TransactionStatusBadge({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement status badge UI
    return const Placeholder();
  }

  // TODO: Implement status color mapping
  Color _getStatusColor() {
    // switch (status) {
    //   case TransactionStatus.completed:
    //     return Colors.green;
    //   case TransactionStatus.pending:
    //     return Colors.orange;
    //   case TransactionStatus.failed:
    //     return Colors.red;
    // }
    return Colors.grey;
  }
}

// TODO: Implement TransactionMetadata
class TransactionMetadata extends StatelessWidget {
  final Transaction transaction;

  const TransactionMetadata({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement metadata UI
    return const Placeholder();
  }
}

void main() {
  // TODO: Test your implementation
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: TransactionDetailsScreen(
          transactionId: 'test-id',
        ),
      ),
    ),
  );
}
