import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/transaction.dart';

// Exercise 3: Complex State Dependencies
// Implementation of state dependencies and synchronization

// Account model with proper equality
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

  Account copyWith({
    String? id,
    String? name,
    double? balance,
    bool? isActive,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Account &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == name &&
          balance == balance &&
          isActive == isActive;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ balance.hashCode ^ isActive.hashCode;
}

// Account state with dependencies
class AccountState extends StateNotifier<Account> {
  final TransactionState _transactionState;
  
  AccountState({
    required TransactionState transactionState,
  }) : _transactionState = transactionState,
       super(
         const Account(
           id: '1',
           name: 'Main Account',
           balance: 1000.0,
           isActive: true,
         ),
       );

  void updateBalance(double amount) {
    if (!state.isActive) {
      throw StateError('Account is not active');
    }
    
    state = state.copyWith(
      balance: state.balance + amount,
    );
  }

  void setActive(bool active) {
    state = state.copyWith(isActive: active);
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  Future<void> processTransaction(Transaction transaction) async {
    if (!state.isActive) {
      throw StateError('Account is not active');
    }

    if (transaction.amount < 0 && state.balance + transaction.amount < 0) {
      throw StateError('Insufficient funds');
    }

    // Update balance first
    updateBalance(transaction.amount);

    // Then add transaction
    await _transactionState.addTransaction(transaction);
  }
}

// Transaction state with dependencies
class TransactionState extends StateNotifier<List<Transaction>> {
  TransactionState() : super([]);

  Future<void> addTransaction(Transaction transaction) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    
    state = [transaction, ...state];
  }

  void removeTransaction(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void clearTransactions() {
    state = [];
  }

  double get totalIncome => state
      .where((t) => t.amount > 0)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => state
      .where((t) => t.amount < 0)
      .fold(0.0, (sum, t) => sum + t.amount.abs());
}

// Providers with dependencies
final transactionStateProvider = StateNotifierProvider<TransactionState, List<Transaction>>((ref) {
  return TransactionState();
});

final accountProvider = StateNotifierProvider<AccountState, Account>((ref) {
  final transactionState = ref.watch(transactionStateProvider.notifier);
  return AccountState(transactionState: transactionState);
});

// Derived providers
final balanceProvider = Provider<double>((ref) {
  return ref.watch(accountProvider).balance;
});

final transactionStatsProvider = Provider<Map<String, double>>((ref) {
  final transactions = ref.watch(transactionStateProvider);
  final transactionState = ref.watch(transactionStateProvider.notifier);
  
  return {
    'income': transactionState.totalIncome,
    'expenses': transactionState.totalExpenses,
    'count': transactions.length.toDouble(),
  };
});

// Account screen implementation
class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);
    final transactions = ref.watch(transactionStateProvider);
    final stats = ref.watch(transactionStatsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAccountCard(context, account, stats),
          const SizedBox(height: 24.0),
          _buildTransactionList(context, transactions),
          const SizedBox(height: 16.0),
          _buildActionButtons(context, ref),
        ],
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    Account account,
    Map<String, double> stats,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  account.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: account.isActive,
                  onChanged: (value) => context
                      .read(accountProvider.notifier)
                      .setActive(value),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              '\$${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Income', stats['income'] ?? 0, Colors.green),
                _buildStatItem('Expenses', stats['expenses'] ?? 0, Colors.red),
                _buildStatItem(
                  'Transactions',
                  stats['count'] ?? 0,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text('No transactions'),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            child: ListTile(
              leading: Icon(
                transaction.amount > 0 ? Icons.add : Icons.remove,
                color: transaction.amount > 0 ? Colors.green : Colors.red,
              ),
              title: Text(transaction.description),
              subtitle: Text(transaction.date.toLocal().toString()),
              trailing: Text(
                '\$${transaction.amount.abs().toStringAsFixed(2)}',
                style: TextStyle(
                  color: transaction.amount > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Income'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _addTransaction(context, ref, true),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.remove),
          label: const Text('Expense'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _addTransaction(context, ref, false),
        ),
      ],
    );
  }

  Future<void> _addTransaction(
    BuildContext context,
    WidgetRef ref,
    bool isIncome,
  ) async {
    try {
      final amount = isIncome ? 100.0 : -50.0;
      final transaction = Transaction(
        id: DateTime.now().toString(),
        amount: amount,
        description: isIncome ? 'Sample Income' : 'Sample Expense',
        date: DateTime.now(),
        status: TransactionStatus.completed,
      );

      await ref.read(accountProvider.notifier).processTransaction(transaction);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
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
          useMaterial3: true,
        ),
        home: const Scaffold(
          appBar: AppBar(
            title: Text('Account Overview'),
          ),
          body: AccountScreen(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise3App());
}
