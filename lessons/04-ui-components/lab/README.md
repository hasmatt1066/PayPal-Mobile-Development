# UI Components Lab (formerly part of Widget Essentials Lab)

## Overview
In this lab, you'll build the UI components for your PayPal Transaction Dashboard app. You'll create reusable widgets that integrate with the domain models, state management, and navigation patterns you've already implemented.

## Prerequisites
- Completion of Domain Foundation lab
- Completion of State Management lab
- Completion of Navigation & Routing lab
- Understanding of Flutter widgets

## Exercise 1: Transaction List Screen

### Objective
Build a responsive transaction list screen that integrates with your state management and navigation.

### Steps to Complete

1. Navigate to the starter code:
```bash
cd starter/lib
```

2. Open `exercise1.dart` in your editor. You'll find:
- A basic screen structure
- TODO comments indicating where to add code
- Helper components

3. Implement the transaction list screen:
   - Add search bar
   - Implement filters
   - Create list view
   - Handle loading states

4. Test your implementation:
```dart
void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: TransactionListScreen(),
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
testWidgets('shows loading state', (tester) async {
  final state = MockTransactionState();
  when(() => state.loading).thenReturn(true);
  
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        transactionProvider.overrideWithValue(state),
      ],
      child: MaterialApp(
        home: TransactionListScreen(),
      ),
    ),
  );
  
  expect(find.byType(LoadingIndicator), findsOneWidget);
});

testWidgets('shows transactions', (tester) async {
  final state = MockTransactionState();
  when(() => state.transactions).thenReturn([
    Transaction(
      id: '1',
      amount: Money(value: 100),
      description: 'Test',
      date: DateTime.now(),
      status: TransactionStatus.completed,
    ),
  ]);
  
  await tester.pumpWidget(/* ... */);
  
  expect(find.byType(TransactionCard), findsOneWidget);
  expect(find.text('Test'), findsOneWidget);
});
```

3. Manual Testing:
   - Test pull-to-refresh
   - Try search functionality
   - Apply filters
   - Check loading states
   - Verify error handling

### Common Issues and Solutions

1. State Integration
```dart
// Wrong:
class TransactionListScreen extends StatelessWidget {
  final List<Transaction> transactions;  // Direct data passing
}

// Right:
class TransactionListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);  // Use provider
  }
}
```

2. Loading States
```dart
// Wrong:
if (loading) {
  showDialog(  // Blocks UI
    context: context,
    builder: (_) => LoadingDialog(),
  );
}

// Right:
if (state.loading) {
  return const LoadingIndicator();  // Inline loading
}
```

## Exercise 2: Transaction Details Screen

### Objective
Create a detailed transaction view with proper navigation integration.

### Steps to Complete

1. Implement the details screen:
```dart
class TransactionDetailsScreen extends ConsumerWidget {
  final String transactionId;
  
  // TODO: Implement:
  // 1. Load transaction details
  // 2. Show timeline
  // 3. Handle updates
  // 4. Manage errors
}
```

### Testing Guide

```dart
testWidgets('loads transaction details', (tester) async {
  final repository = MockTransactionRepository();
  when(() => repository.getTransactionById('1'))
      .thenAnswer((_) async => Transaction(...));
      
  await tester.pumpWidget(/* ... */);
  
  expect(find.text('Transaction Details'), findsOneWidget);
  // Verify other UI elements
});
```

## Exercise 3: Reusable Components

### Objective
Build a set of reusable UI components for consistent user experience.

### Steps to Complete

1. Create the component library:
```
lib/
└── features/
    └── transactions/
        └── presentation/
            └── widgets/
                ├── loading_states.dart
                ├── error_displays.dart
                └── filter_widgets.dart
```

### Integration Steps

After completing the exercises, integrate your UI components into the main app:

1. Navigate to my-paypal-app:
```bash
cd ../../my-paypal-app
```

2. Create the presentation directories:
```bash
mkdir -p lib/features/transactions/presentation/{screens,widgets}
```

3. Copy your implementations:
```bash
cp exercise1.dart lib/features/transactions/presentation/screens/transaction_list_screen.dart
cp exercise2.dart lib/features/transactions/presentation/screens/transaction_details_screen.dart
cp -r widgets/ lib/features/transactions/presentation/
```

## Integration Checklist

- [ ] Screens properly use state management
- [ ] Navigation is working correctly
- [ ] Loading states are implemented
- [ ] Error handling is complete
- [ ] Components are reusable
- [ ] Tests cover main functionality
- [ ] UI is responsive

## Preview: Tomorrow's Additions

In tomorrow's Platform Integration lab, you'll:
1. Add platform-specific UI
2. Implement biometric auth
3. Handle notifications
4. Prepare for deployment

These will complete your transaction dashboard app with platform-specific features.

## Additional Resources

- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Material Design Guidelines](https://material.io/design)
- [Responsive Design](https://flutter.dev/docs/development/ui/layout/responsive)
- [Widget Testing](https://flutter.dev/docs/cookbook/testing/widget/introduction)

Remember: UI components should integrate cleanly with your existing architecture, leveraging the state management and navigation patterns you've already implemented.
