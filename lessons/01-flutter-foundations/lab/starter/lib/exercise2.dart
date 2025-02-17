import 'package:flutter/material.dart';

// Exercise 2: Widget Composition
// Create reusable and efficient widget components

// TODO: Create Transaction model class
// Hint: Include amount, description, date, and status

class TransactionItem extends StatelessWidget {
  // TODO: Add required parameters
  // TODO: Use const constructor
  
  @override
  Widget build(BuildContext context) {
    // TODO: Implement an efficient widget structure
    // Hint: Use Card with Row/Column combination
    // Hint: Show amount, description, date, and status
    return Container();
  }
}

class TransactionList extends StatelessWidget {
  // TODO: Add proper parameters and const constructor
  // TODO: Add list of transactions parameter
  
  @override
  Widget build(BuildContext context) {
    // TODO: Use ListView.builder for efficient list rendering
    // Hint: Create TransactionItem widgets for each transaction
    return Container();
  }
}

// Sample data provider
class TransactionDataProvider {
  // TODO: Implement method to generate sample transactions
  // Hint: Return a list of Transaction objects
  static List<dynamic> getSampleTransactions() {
    return [];
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
        // TODO: Use TransactionList widget with sample data
        body: Container(),
      ),
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
