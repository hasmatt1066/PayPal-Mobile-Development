import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/navigation/router.dart';
import 'features/transactions/domain/repositories/transaction_repository.dart';
import 'features/transactions/data/repositories/transaction_repository_impl.dart';
import 'features/transactions/presentation/state/transaction_state.dart';

void main() {
  runApp(const PayPalApp());
}

class PayPalApp extends StatelessWidget {
  const PayPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide repository
        Provider<TransactionRepository>(
          create: (_) => TransactionRepositoryImpl(),
        ),
        // Provide state management
        ChangeNotifierProxyProvider<TransactionRepository, TransactionState>(
          create: (context) => TransactionState(
            repository: context.read<TransactionRepository>(),
          ),
          update: (context, repository, previous) => 
            previous ?? TransactionState(repository: repository),
        ),
      ],
      child: MaterialApp(
        title: 'PayPal Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
