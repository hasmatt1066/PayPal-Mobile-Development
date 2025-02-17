import 'package:flutter/material.dart';
import 'features/transactions/data/datasources/transaction_api.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/presentation/widgets/transaction_screen.dart';

void main() {
  // Set up dependencies
  final api = TransactionApi(
    baseUrl: 'https://api.example.com', // Replace with actual API URL
  );
  
  final repository = TransactionRepositoryImpl(
    api: api,
  );

  // Run the app
  runApp(
    Exercise3App(
      repository: repository,
    ),
  );
}
