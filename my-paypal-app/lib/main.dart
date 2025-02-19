import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: Day 1 - Import transaction card and filter components
// TODO: Day 2 - Import transaction details and loading components
// TODO: Day 3 - Import state management
// TODO: Day 4 - Import navigation

void main() {
  runApp(const PayPalApp());
}

class PayPalApp extends StatelessWidget {
  const PayPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayPal Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TransactionListScreen(),
    );
  }
}

// Placeholder screen - Will be enhanced each day
class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Day 1 - Add search bar and filters here
            const Text(
              'Welcome to PayPal Dashboard',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Complete Lab 1 to implement the transaction list',
              style: TextStyle(fontSize: 16),
            ),
            // TODO: Day 1 - Add transaction list here
            // TODO: Day 2 - Add loading states
            // TODO: Day 3 - Connect state management
            // TODO: Day 4 - Add navigation
          ],
        ),
      ),
    );
  }
}

// Placeholder widgets - Will be implemented in labs
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Day 1 - Implement search bar
    return const Placeholder(
      fallbackHeight: 50,
    );
  }
}

class DateFilter extends StatelessWidget {
  const DateFilter({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Day 1 - Implement date filter
    return const Placeholder(
      fallbackHeight: 40,
    );
  }
}

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Day 1 - Implement category filter
    return const Placeholder(
      fallbackHeight: 40,
    );
  }
}

// This placeholder shows what will be implemented each day
class ComingSoon extends StatelessWidget {
  final String day;
  final String feature;

  const ComingSoon({
    super.key,
    required this.day,
    required this.feature,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Coming $day',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(feature),
          ],
        ),
      ),
    );
  }
}
