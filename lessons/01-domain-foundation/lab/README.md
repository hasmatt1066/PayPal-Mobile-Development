# Domain Foundation Lab (formerly: Flutter Foundations Lab)

## Overview
In this lab, you'll build the foundational domain layer for your PayPal Transaction Dashboard app. You'll implement core models, interfaces, and patterns that will serve as the foundation for the entire application.

## Prerequisites
- Flutter development environment set up
- Basic Dart programming knowledge
- Understanding of OOP principles
- Familiarity with clean architecture concepts

## Exercise 1: Transaction Model

### Objective
Build a robust Transaction model with proper validation, business logic, and value objects.

### Steps to Complete

1. Navigate to the starter code:
```bash
cd starter/lib
```

2. Open `exercise1.dart` in your editor. You'll find:
- A basic `Transaction` class structure
- TODO comments indicating where to add code
- Helper classes and models

3. Implement the `Transaction` model:
   - Add validation rules
   - Implement business logic
   - Create value objects
   - Add helper methods

4. Test your implementation:
```dart
void main() {
  final transaction = Transaction(
    id: 'TXN-123',
    amount: Money(value: 100.50),
    description: 'Test Payment',
    date: DateTime.now(),
    status: TransactionStatus.completed,
  );

  print(transaction.formattedAmount);  // Should print: $100.50
  print(transaction.isCredit);         // Should print: true
}
```

### Testing Guide

1. Run the tests:
```bash
flutter test test/exercise1_test.dart
```

2. Verify the following test cases:
```dart
test('validates transaction data', () {
  expect(
    () => Transaction(
      id: '',  // Invalid: empty ID
      amount: Money(value: 100),
      description: 'Test',
      date: DateTime.now(),
      status: TransactionStatus.completed,
    ),
    throwsA(isA<InvalidTransactionException>()),
  );
});

test('handles money operations', () {
  final m1 = Money(value: 100);
  final m2 = Money(value: 200);
  
  final sum = m1 + m2;
  expect(sum.value, 300);
  expect(sum.formatted, '\$300.00');
});
```

3. Manual Testing:
   - Create transactions with various amounts
   - Test validation rules
   - Verify formatting
   - Check business logic

### Common Issues and Solutions

1. Value Objects
```dart
// Wrong:
class Transaction {
  final double amount;  // Using primitive type
}

// Right:
class Transaction {
  final Money amount;  // Using value object
}
```

2. Validation
```dart
// Wrong:
if (!isValid()) {
  return false;  // Silent failure
}

// Right:
if (id.isEmpty) {
  throw InvalidTransactionException('ID cannot be empty');
}
```

## Exercise 2: Repository Interface

### Objective
Create a repository interface that defines how transaction data will be accessed.

### Steps to Complete

1. Implement the repository interface:
```dart
abstract class TransactionRepository {
  // TODO: Define methods for:
  // 1. Fetching transactions
  // 2. Getting by ID
  // 3. Filtering by date
  // 4. Saving transactions
}
```

2. Add proper error handling:
```dart
// TODO: Implement exception hierarchy:
// 1. Base exception
// 2. Not found exception
// 3. Validation exception
```

### Testing Guide

```dart
void main() {
  group('TransactionRepository', () {
    late MockTransactionRepository repository;
    
    setUp(() {
      repository = MockTransactionRepository();
    });
    
    test('handles not found error', () async {
      when(() => repository.getTransactionById('invalid'))
          .thenThrow(TransactionNotFoundException('invalid'));
          
      expect(
        () => repository.getTransactionById('invalid'),
        throwsA(isA<TransactionNotFoundException>()),
      );
    });
  });
}
```

## Exercise 3: Clean Architecture Setup

### Objective
Set up the clean architecture structure for the transactions feature.

### Steps to Complete

1. Create the directory structure:
```
lib/
├── features/
│   └── transactions/
│       ├── domain/
│       │   ├── models/
│       │   └── repositories/
│       ├── data/
│       │   └── repositories/
│       └── presentation/
│           └── state/
```

2. Implement the interfaces and models in each layer.

### Integration Steps

After completing the exercises, integrate your domain layer into the main app:

1. Navigate to my-paypal-app:
```bash
cd ../../my-paypal-app
```

2. Create the domain directories:
```bash
mkdir -p lib/features/transactions/domain/{models,repositories}
```

3. Copy your implementations:
```bash
cp exercise1.dart lib/features/transactions/domain/models/transaction.dart
cp exercise2.dart lib/features/transactions/domain/repositories/transaction_repository.dart
```

## Integration Checklist

- [ ] Models properly encapsulate data
- [ ] Value objects are immutable
- [ ] Repository interface is complete
- [ ] Error handling is robust
- [ ] Tests cover core functionality
- [ ] Directory structure follows clean architecture
- [ ] Documentation is complete

## Preview: Tomorrow's Additions

In tomorrow's State Management lab, you'll:
1. Implement the repository interface
2. Add state management
3. Handle data persistence
4. Manage error states

These will build upon today's domain layer, adding the state management layer that connects your models to the UI.

## Additional Resources

- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Value Objects](https://martinfowler.com/bliki/ValueObject.html)
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

Remember: A solid domain foundation is crucial for building maintainable applications. Take time to understand these patterns as they'll influence every other aspect of your app development.
