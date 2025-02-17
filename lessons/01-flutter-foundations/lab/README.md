# Flutter Foundations Lab

## Overview
This lab will help you practice fundamental Flutter concepts through hands-on exercises. You'll build widgets, handle user interactions, and manage application state.

## Prerequisites
- Flutter development environment set up
- Basic understanding of Dart programming
- Familiarity with widget concepts

## Exercise 1: Basic Widget Creation

### Objective
Create a custom transaction card widget that displays financial information with proper formatting and styling.

### Steps to Complete

1. Navigate to the starter code:
```bash
cd starter/lib
```

2. Open `exercise1.dart` in your editor. You'll find:
- A basic `TransactionCard` widget structure
- TODO comments indicating where to add code
- Helper classes and models

3. Implement the `TransactionCard` widget:
   - Add required fields for transaction data
   - Implement proper styling and layout
   - Handle currency formatting
   - Add status indicators

4. Test your implementation:
```dart
void main() {
  // Create test transaction
  final transaction = Transaction(
    id: 'TXN-123',
    amount: 100.50,
    description: 'Test Payment',
    date: DateTime.now(),
    status: TransactionStatus.completed,
  );

  // Run the test app
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: TransactionCard(
            transaction: transaction,
          ),
        ),
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
testWidgets('displays transaction amount', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TransactionCard(
        transaction: Transaction(
          id: 'TXN-123',
          amount: 100.50,
          description: 'Test',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
      ),
    ),
  );

  // Check amount formatting
  expect(find.text('\$100.50'), findsOneWidget);
});

testWidgets('shows correct status color', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TransactionCard(
        transaction: Transaction(
          id: 'TXN-123',
          amount: 100.50,
          description: 'Test',
          date: DateTime.now(),
          status: TransactionStatus.completed,
        ),
      ),
    ),
  );

  // Find status indicator
  final indicator = tester.widget<Container>(
    find.byKey(const Key('status-indicator')),
  );

  // Check color for completed status
  expect(
    (indicator.decoration as BoxDecoration).color,
    Colors.green,
  );
});
```

3. Manual Testing:
   - Run the app: `flutter run`
   - Check transaction amount formatting
   - Verify status indicator colors
   - Test different transaction states
   - Ensure proper layout on various screen sizes

### Common Issues and Solutions

1. Currency Formatting
```dart
// Wrong:
Text('\$$amount')

// Right:
Text('\$${amount.toStringAsFixed(2)}')
```

2. Status Colors
```dart
// Wrong:
color: status == TransactionStatus.completed ? Colors.green : Colors.red

// Right:
color: _getStatusColor(status)

Color _getStatusColor(TransactionStatus status) {
  switch (status) {
    case TransactionStatus.completed:
      return Colors.green;
    case TransactionStatus.pending:
      return Colors.orange;
    case TransactionStatus.failed:
      return Colors.red;
  }
}
```

3. Layout Issues
```dart
// Wrong:
Column(
  children: [
    Text(description),
    Text(amount),
  ],
)

// Right:
Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMd().format(date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      Text(
        '\$${amount.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ],
  ),
)
```

### Completion Checklist

- [ ] Transaction amount is properly formatted
- [ ] Status indicator shows correct color
- [ ] Date is properly formatted
- [ ] Layout is responsive
- [ ] All tests pass
- [ ] Code is properly formatted and documented

### Additional Resources

- [Flutter Layout Guide](https://flutter.dev/docs/development/ui/layout)
- [Text Styling](https://api.flutter.dev/flutter/painting/TextStyle-class.html)
- [Widget Testing](https://flutter.dev/docs/cookbook/testing/widget/introduction)
- [Material Design Guidelines](https://material.io/design)

## Next Steps

Once you've completed Exercise 1:
1. Review the solution code in `solution/lib/exercise1.dart`
2. Compare your implementation with the solution
3. Note any differences in approach
4. Move on to Exercise 2

Remember: The goal is to understand the concepts, not just complete the exercise. Take time to experiment with different approaches and understand why certain patterns are used.
