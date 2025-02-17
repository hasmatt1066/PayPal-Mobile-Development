import 'package:flutter/material.dart';

// Exercise 3: Performance Optimization
// Implement an efficient transaction list with optimized performance

// Transaction model
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

// TODO: Implement optimized transaction list
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  
  const TransactionList({
    required this.transactions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement efficient list rendering
    // Hint: Use ListView.builder for better performance
    return Container();
  }
}

// TODO: Implement optimized list item
class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  
  const TransactionListItem({
    required this.transaction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement efficient item rendering
    // Hint: Use const constructor and minimize rebuilds
    return Container();
  }
}

// Sample data provider
class TransactionDataProvider {
  static List<Transaction> generateTransactions(int count) {
    return List.generate(
      count,
      (index) => Transaction(
        id: 'TXN-$index',
        amount: (index + 1) * 10.0,
        description: 'Transaction $index',
        date: DateTime.now().subtract(Duration(days: index)),
        status: TransactionStatus.values[index % 3],
      ),
    );
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
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Optimized Transaction List'),
        ),
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
