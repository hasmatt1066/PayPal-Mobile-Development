import 'package:flutter/material.dart';
import 'models/transaction.dart';

// Exercise 1: Basic State Management
// Implement secure state management for financial data

// TODO: Implement secure transaction state
class TransactionState extends ChangeNotifier {
  final List<Transaction> _transactions = [];
  bool _loading = false;
  String? _error;
  
  // TODO: Add secure getters
  // TODO: Add state update methods
  // TODO: Add error handling
  
  @override
  void dispose() {
    // TODO: Implement secure cleanup
    super.dispose();
  }
}

// Example transaction screen
class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement state consumption
    return Container();
  }
}

// Sample data provider
class TransactionDataProvider {
  static List<Transaction> generateTransactions() {
    return List.generate(
      10,
      (index) => Transaction(
        id: 'TXN-$index',
        amount: (index + 1) * 100.0,
        description: 'Transaction $index',
        date: DateTime.now().subtract(Duration(days: index)),
        status: TransactionStatus.values[index % 3],
      ),
    );
  }
}

// Main app widget for testing
class Exercise1App extends StatelessWidget {
  const Exercise1App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management Lab - Exercise 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: TransactionScreen(),
      ),
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
