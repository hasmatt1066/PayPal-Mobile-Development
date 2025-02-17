import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Exercise 3: Performance Optimization
// Implementation of an efficient transaction list with optimized performance

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
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}

// Optimized transaction list with efficient rendering
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  
  const TransactionList({
    required this.transactions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Use builder for efficient item creation
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionListItem(
          key: ValueKey(transactions[index].id),
          transaction: transactions[index],
        );
      },
      // Performance optimizations
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
    );
  }
}

// Optimized list item with minimal rebuilds
class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  
  // Use const constructor for widget reuse
  const TransactionListItem({
    required this.transaction,
    Key? key,
  }) : super(key: key);

  // Static formatters to avoid recreation
  static final _dateFormatter = DateFormat('MMM d, y');
  static final _currencyFormatter = NumberFormat.currency(symbol: '\$');
  
  // Static styles to avoid recreation
  static const _titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  static const _subtitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    // Use RepaintBoundary for complex items
    return RepaintBoundary(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: ListTile(
          leading: _buildStatusIndicator(),
          title: Text(
            transaction.description,
            style: _titleStyle,
          ),
          subtitle: Text(
            _dateFormatter.format(transaction.date),
            style: _subtitleStyle,
          ),
          trailing: Text(
            _currencyFormatter.format(transaction.amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: transaction.amount >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  // Static method to avoid recreation
  Color _getStatusColor() {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.failed:
        return Colors.red;
    }
  }
}

// Sample data provider with caching
class TransactionDataProvider {
  // Cache generated transactions
  static final Map<int, List<Transaction>> _cache = {};

  static List<Transaction> generateTransactions(int count) {
    // Return cached transactions if available
    if (_cache.containsKey(count)) {
      return _cache[count]!;
    }

    // Generate and cache new transactions
    final transactions = List.generate(
      count,
      (index) => Transaction(
        id: 'TXN-$index',
        amount: (index + 1) * 10.0,
        description: 'Transaction $index',
        date: DateTime.now().subtract(Duration(days: index)),
        status: TransactionStatus.values[index % 3],
      ),
    );

    _cache[count] = transactions;
    return transactions;
  }
}

// Main app widget for testing
class Exercise3App extends StatelessWidget {
  const Exercise3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate sample transactions
    final transactions = TransactionDataProvider.generateTransactions(1000);

    return MaterialApp(
      title: 'Widget Essentials Lab - Exercise 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Optimize card theme
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Optimized Transaction List'),
        ),
        // Use const where possible
        body: TransactionList(
          transactions: transactions,
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise3App());
}
