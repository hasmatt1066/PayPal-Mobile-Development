// Exercise 3: Implement Reusable UI Components

import 'package:flutter/material.dart';

// Import from previous exercises
import '../../../02-state-management/lab/solution/lib/exercise1.dart';

// TODO: Implement LoadingOverlay
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    required this.child,
    required this.isLoading,
    this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement loading overlay UI
    // return Stack(
    //   children: [
    //     child,
    //     if (isLoading)
    //       Container(
    //         color: Colors.black54,
    //         child: Center(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const CircularProgressIndicator(),
    //               if (message != null) ...[
    //                 const SizedBox(height: 16),
    //                 Text(
    //                   message!,
    //                   style: const TextStyle(color: Colors.white),
    //                 ),
    //               ],
    //             ],
    //           ),
    //         ),
    //       ),
    //   ],
    // );
    return const Placeholder();
  }
}

// TODO: Implement ErrorCard
class ErrorCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryText;

  const ErrorCard({
    required this.title,
    required this.message,
    this.onRetry,
    this.retryText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement error card UI
    return const Placeholder();
  }
}

// TODO: Implement StatusChip
class StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const StatusChip({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement status chip UI
    return const Placeholder();
  }
}

// TODO: Implement AmountDisplay
class AmountDisplay extends StatelessWidget {
  final Money amount;
  final TextStyle? style;
  final bool showSign;

  const AmountDisplay({
    required this.amount,
    this.style,
    this.showSign = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement amount display UI
    return const Placeholder();
  }

  // TODO: Implement amount formatting
  String _formatAmount() {
    // final sign = showSign && amount.value > 0 ? '+' : '';
    // return '$sign${amount.formatted}';
    return '';
  }
}

// TODO: Implement DateRangePicker
class DateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange?> onChanged;
  final String? label;

  const DateRangePicker({
    required this.startDate,
    required this.endDate,
    required this.onChanged,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement date range picker UI
    return const Placeholder();
  }

  // TODO: Implement date formatting
  String _formatDateRange() {
    // if (startDate == null || endDate == null) {
    //   return 'Select date range';
    // }
    // final start = DateFormat.MMMd().format(startDate!);
    // final end = DateFormat.MMMd().format(endDate!);
    // return '$start - $end';
    return '';
  }
}

// TODO: Implement SearchField
class SearchField extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final VoidCallback? onClear;

  const SearchField({
    required this.value,
    required this.onChanged,
    this.hint,
    this.onClear,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement search field UI
    return const Placeholder();
  }
}

// TODO: Implement EmptyStateIllustration
class EmptyStateIllustration extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateIllustration({
    required this.message,
    required this.icon,
    this.subMessage,
    this.onAction,
    this.actionLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement empty state UI
    return const Placeholder();
  }
}

void main() {
  // TODO: Test your implementations
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Test loading overlay
              LoadingOverlay(
                isLoading: true,
                message: 'Loading...',
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 20),

              // Test error card
              ErrorCard(
                title: 'Error',
                message: 'Something went wrong',
                onRetry: () {},
                retryText: 'Try Again',
              ),

              const SizedBox(height: 20),

              // Test status chip
              StatusChip(
                label: 'Active',
                color: Colors.green,
                icon: Icons.check_circle,
              ),

              const SizedBox(height: 20),

              // Test amount display
              AmountDisplay(
                amount: Money(value: 100.50),
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 20),

              // Test date range picker
              DateRangePicker(
                startDate: DateTime.now(),
                endDate: DateTime.now().add(const Duration(days: 7)),
                onChanged: (range) {},
                label: 'Select dates',
              ),

              const SizedBox(height: 20),

              // Test search field
              SearchField(
                value: '',
                onChanged: (value) {},
                hint: 'Search transactions',
                onClear: () {},
              ),

              const SizedBox(height: 20),

              // Test empty state
              EmptyStateIllustration(
                message: 'No transactions found',
                subMessage: 'Try adjusting your filters',
                icon: Icons.search_off,
                onAction: () {},
                actionLabel: 'Clear Filters',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
