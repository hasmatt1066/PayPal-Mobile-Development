import 'package:flutter/material.dart';

// Exercise 2: Widget Composition
// Implementation of reusable and efficient widget components

enum TransactionStatus {
  completed,
  pending,
  failed,
}

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
          amount == other.amount &&
          description == other.description &&
          date == other.date &&
          status == other.status;

  @override
  int get hashCode =>
      id.hashCode ^
      amount.hashCode ^
      description.hashCode ^
      date.hashCode ^
      status.hashCode;
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({
    required this.transaction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildStatusIndicator(),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    _formatDate(transaction.date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            _buildAmount(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final color = _getStatusColor();
    return Container(
      width: 12.0,
      height: 12.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildAmount() {
    return Text(
      '\$${transaction.amount.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: transaction.amount >= 0 ? Colors.green : Colors.red,
      ),
    );
  }

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

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({
    required this.transactions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return TransactionItem(
          transaction: transactions[index],
        );
      },
    );
  }
}

// Sample data provider
class TransactionDataProvider {
  static List<Transaction> getSampleTransactions() {
    return [
      Transaction(
        id: '1',
        amount: 120.50,
        description: 'Grocery Shopping',
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '2',
        amount: -45.00,
        description: 'Restaurant Bill',
        date: DateTime.now().subtract(const Duration(days: 2)),
        status: TransactionStatus.completed,
      ),
      Transaction(
        id: '3',
        amount: 850.00,
        description: 'Rent Payment',
        date: DateTime.now(),
        status: TransactionStatus.pending,
      ),
      Transaction(
        id: '4',
        amount: 75.20,
        description: 'Online Purchase',
        date: DateTime.now().subtract(const Duration(days: 3)),
        status: TransactionStatus.failed,
      ),
    ];
  }
}

// Main app widget for testing
class Exercise2App extends StatelessWidget {
  const Exercise2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Foundations Lab - Exercise 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Transaction List'),
        ),
        body: TransactionList(
          transactions: TransactionDataProvider.getSampleTransactions(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
