import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/transaction.dart';

// Exercise 3: Complex State Dependencies
// Implement state dependencies and synchronization

// Account model
class Account {
  final String id;
  final String name;
  final double balance;
  final bool isActive;

  const Account({
    required this.id,
    required this.name,
    required this.balance,
    required this.isActive,
  });
}

// TODO: Implement account state
class AccountState extends StateNotifier<Account> {
  AccountState() : super(
    const Account(
      id: '1',
      name: 'Main Account',
      balance: 1000.0,
      isActive: true,
    ),
  );

  // TODO: Add dependencies
  // TODO: Implement state updates
  // TODO: Handle synchronization
}

// TODO: Implement transaction state
class TransactionState extends StateNotifier<List<Transaction>> {
  TransactionState() : super([]);

  // TODO: Add dependencies
  // TODO: Implement state updates
  // TODO: Handle synchronization
}

// Example providers setup
final accountProvider = StateNotifierProvider<AccountState, Account>((ref) {
  // TODO: Set up provider with dependencies
  return AccountState();
});

final transactionProvider = StateNotifierProvider<TransactionState, List<Transaction>>((ref) {
  // TODO: Set up provider with dependencies
  return TransactionState();
});

// Example account screen
class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement account screen with transaction list
    return Container();
  }
}

// Main app widget for testing
class Exercise3App extends StatelessWidget {
  const Exercise3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'State Management Lab - Exercise 3',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Scaffold(
          body: AccountScreen(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise3App());
}
