import 'package:flutter/material.dart';

// Exercise 3: Enterprise Feature Structure
// Implement a feature using proper directory structure and patterns

// Domain Layer
// TODO: Create Transaction model in domain/models/transaction.dart
// TODO: Create TransactionRepository interface in domain/repositories/transaction_repository.dart
// TODO: Create TransactionException class in domain/exceptions/transaction_exception.dart

// Data Layer
// TODO: Create TransactionRepositoryImpl in data/repositories/transaction_repository_impl.dart
// TODO: Create TransactionApi in data/datasources/transaction_api.dart
// TODO: Create TransactionMapper in data/mappers/transaction_mapper.dart

// Presentation Layer
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // TODO: Inject repository using dependency injection
  // TODO: Implement state management
  // TODO: Handle loading, error, and success states
  
  @override
  void initState() {
    super.initState();
    // TODO: Load transactions
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement UI with proper error handling and loading states
    return Container();
  }
}

// Main app widget for testing
class Exercise3App extends StatelessWidget {
  const Exercise3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Foundations Lab - Exercise 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TransactionScreen(),
    );
  }
}

void main() {
  // TODO: Set up dependency injection
  runApp(const Exercise3App());
}
