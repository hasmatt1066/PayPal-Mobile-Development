import 'package:flutter/material.dart';
import '../../domain/models/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../../domain/exceptions/transaction_exception.dart';

// Presentation layer - Main transaction screen
class TransactionScreen extends StatefulWidget {
  final TransactionRepository repository;

  const TransactionScreen({
    required this.repository,
    Key? key,
  }) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Transaction>? _transactions;
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final transactions = await widget.repository.getTransactions();

      setState(() {
        _transactions = transactions;
        _loading = false;
      });
    } on TransactionException catch (e) {
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _loadTransactions,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTransactions,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_transactions == null || _transactions!.isEmpty) {
      return const Center(
        child: Text('No transactions found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTransactions,
      child: ListView.builder(
        itemCount: _transactions!.length,
        itemBuilder: (context, index) {
          final transaction = _transactions![index];
          return _TransactionListItem(transaction: transaction);
        },
      ),
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const _TransactionListItem({
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
        subtitle: Text(_formatDate(transaction.date)),
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

// Main app widget for testing
class Exercise3App extends StatelessWidget {
  final TransactionRepository repository;

  const Exercise3App({
    required this.repository,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Foundations Lab - Exercise 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TransactionScreen(repository: repository),
    );
  }
}
