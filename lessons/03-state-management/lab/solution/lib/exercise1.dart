import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/transaction.dart';

// Exercise 1: Basic State Management
// Implementation of secure state management for financial data

class TransactionState extends ChangeNotifier {
  final List<Transaction> _transactions = [];
  bool _loading = false;
  String? _error;
  DateTime? _lastUpdated;
  final List<String> _auditLog = [];

  // Secure getters that prevent direct state modification
  UnmodifiableListView<Transaction> get transactions => 
      UnmodifiableListView(_transactions);
  bool get loading => _loading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  UnmodifiableListView<String> get auditLog => 
      UnmodifiableListView(_auditLog);

  // Secure state update methods
  Future<void> loadTransactions() async {
    try {
      _setLoading(true);
      _logAction('Loading transactions');

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      final data = TransactionDataProvider.generateTransactions();
      
      _transactions.clear();
      _transactions.addAll(data);
      _lastUpdated = DateTime.now();
      
      _logAction('Loaded ${data.length} transactions');
      notifyListeners();

    } catch (e) {
      _setError('Failed to load transactions: $e');
      _logAction('Error loading transactions: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      _setLoading(true);
      _logAction('Adding transaction ${transaction.id}');

      // Validate transaction
      if (!transaction.isValid()) {
        throw StateError('Invalid transaction data');
      }

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _transactions.insert(0, transaction);
      _lastUpdated = DateTime.now();
      
      _logAction('Added transaction ${transaction.id}');
      notifyListeners();

    } catch (e) {
      _setError('Failed to add transaction: $e');
      _logAction('Error adding transaction: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    _error = null;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _logAction(String action) {
    final timestamp = DateTime.now().toIso8601String();
    _auditLog.add('[$timestamp] $action');
  }

  @override
  void dispose() {
    _logAction('Disposing state');
    _transactions.clear();
    super.dispose();
  }
}

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionState>(
      builder: (context, state, child) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<TransactionState>().loadTransactions(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: state.transactions.isEmpty
                  ? const Center(
                      child: Text('No transactions'),
                    )
                  : ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactions[index];
                        return TransactionListItem(transaction: transaction);
                      },
                    ),
            ),
            if (state.lastUpdated != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Last updated: ${state.lastUpdated!.toLocal()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        );
      },
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({
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
      child: ListTile(
        leading: _buildStatusIndicator(),
        title: Text(transaction.description),
        subtitle: Text(transaction.date.toLocal().toString()),
        trailing: Text(
          '\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.amount >= 0 ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
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
      home: ChangeNotifierProvider(
        create: (_) => TransactionState()..loadTransactions(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transactions'),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => context
                      .read<TransactionState>()
                      .loadTransactions(),
                ),
              ),
            ],
          ),
          body: const TransactionScreen(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
