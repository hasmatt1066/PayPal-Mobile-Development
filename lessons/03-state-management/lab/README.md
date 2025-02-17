# State Management Lab

## Overview
This lab will help you practice state management patterns in Flutter. You'll implement secure and efficient state management solutions for a financial application.

## Prerequisites
- Flutter development environment set up
- Completion of Widget Essentials lab
- Understanding of state management concepts
- Familiarity with Provider/Riverpod patterns

## Exercise 1: Basic State Management

### Objective
Implement secure state management for financial data using proper patterns and error handling.

### Steps to Complete

1. Navigate to the starter code:
```bash
cd starter/lib
```

2. Open `exercise1.dart` in your editor. You'll find:
- A basic `TransactionState` class structure
- TODO comments indicating where to add code
- Helper models and classes

3. Implement the `TransactionState` class:
   - Add secure state management
   - Implement proper error handling
   - Add audit logging
   - Handle state updates securely

4. Test your implementation:
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionState(),
      child: MaterialApp(
        home: TransactionScreen(),
      ),
    ),
  );
}
```

### Testing Guide

1. Run the tests:
```bash
flutter test test/exercise1_test.dart
```

2. Verify the following test cases:
```dart
test('loads transactions securely', () async {
  final state = TransactionState();
  
  await state.loadTransactions();
  
  expect(state.transactions, isNotEmpty);
  expect(state.error, isNull);
  expect(state.loading, isFalse);
});

test('handles loading errors', () async {
  final state = TransactionState(
    api: MockTransactionApi(shouldFail: true),
  );
  
  await state.loadTransactions();
  
  expect(state.error, isNotNull);
  expect(state.loading, isFalse);
});
```

3. Manual Testing:
   - Run the app: `flutter run`
   - Test loading states
   - Verify error handling
   - Check audit logging
   - Test state updates

### Common Issues and Solutions

1. State Updates
```dart
// Wrong:
_transactions.add(transaction);
notifyListeners();

// Right:
setState(() {
  _transactions = [..._transactions, transaction];
});
```

2. Error Handling
```dart
// Wrong:
try {
  await api.fetchTransactions();
} catch (e) {
  print(e);
}

// Right:
try {
  _setLoading(true);
  final data = await api.fetchTransactions();
  _transactions = data;
  _error = null;
} catch (e) {
  _error = 'Failed to load transactions: $e';
  await _logger.logError(_error);
} finally {
  _setLoading(false);
}
```

3. Secure State Access
```dart
// Wrong:
List<Transaction> get transactions => _transactions;

// Right:
UnmodifiableListView<Transaction> get transactions => 
    UnmodifiableListView(_transactions);
```

### Completion Checklist

- [ ] State is managed securely
- [ ] Error handling is implemented
- [ ] Loading states are handled
- [ ] Audit logging is in place
- [ ] State updates are atomic
- [ ] All tests pass
- [ ] Code is properly formatted and documented

### Additional Resources

- [Provider Documentation](https://pub.dev/packages/provider)
- [State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [Error Handling](https://dart.dev/guides/libraries/library-tour#handling-errors)
- [Immutable Data](https://dart.dev/guides/libraries/library-tour#unmodifiable-collections)

## Next Steps

Once you've completed Exercise 1:
1. Review the solution code in `solution/lib/exercise1.dart`
2. Compare your implementation with the solution
3. Note any differences in approach
4. Move on to Exercise 2

Remember: Focus on security and immutability when managing financial data. Take time to understand how state changes affect the UI and how to properly handle sensitive information.
