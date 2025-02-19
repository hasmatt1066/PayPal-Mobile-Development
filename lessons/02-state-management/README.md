# State Management (Widget Essentials)

**Time Required:** 120 minutes

**Learning Objectives:** By the end of this lesson, engineers will be able to:
- Implement secure state management patterns
- Handle complex state dependencies
- Manage error states and loading states
- Implement proper data persistence
- Apply state testing patterns


## Prerequisites
- Completion of Domain Foundation lesson
- Understanding of Flutter basics
- Familiarity with async programming


## Development Environment Setup
**Time Required:** 15 minutes

### Project Navigation
1. Navigate to this lesson's directory:
   ```bash
   cd lessons/02-state-management/lab/starter
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

> 💡 **Pro Tip:**  
> If you closed your IDE since the last lesson, reopen the project:
> - VS Code: `code .`
> - Android Studio: Open the `starter` directory

### Project Structure
```
lib/
├── features/
│   └── transactions/
│       ├── presentation/
│       │   └── state/
│       │       ├── transaction_state.dart
│       │       └── filter_state.dart
│       └── data/
│           └── repositories/
│               └── transaction_repository_impl.dart
```

### Verification
1. Run the starter app:
   ```bash
   flutter run
   ```

2. Verify the following:
   - App launches successfully
   - No console errors
   - Hot reload works (press 'r' in terminal)

> ⚠️ **Warning:**  
> If you encounter any errors, ensure all dependencies are properly installed and you're in the correct directory.


## Introduction
While the original Widget Essentials lesson focused on UI components, we've moved state management earlier in the course to follow professional development practices. The widget concepts aren't gone - they're now presented after you understand how to properly manage application state.

> 💡 **Key Concept:**  
> State management should be implemented before UI components to ensure proper data flow, error handling, and testing capabilities.


## Lesson Roadmap

### 1. Provider Setup (30 min)
- State containers
- Dependency injection
- Provider hierarchy
- State initialization

### 2. State Management (45 min)
- Transaction state
- Filter state
- Loading state
- Error handling

### 3. Testing (45 min)
- State testing
- Mock providers
- Integration tests
- Error scenarios


## State Management Implementation

Let's implement secure state management:

<details>
<summary>View Implementation</summary>

```dart
// lib/features/transactions/presentation/state/transaction_state.dart

class TransactionState extends ChangeNotifier {
    final TransactionRepository repository;
    List<Transaction> _transactions = [];
    bool _loading = false;
    String? _error;
    
    TransactionState({required this.repository}) {
        _loadInitialData();
    }
    
    // Getters with immutability
    List<Transaction> get transactions => 
        List.unmodifiable(_transactions);
    bool get loading => _loading;
    String? get error => _error;
    
    Future<void> _loadInitialData() async {
        try {
            _setLoading(true);
            final data = await repository.getTransactions();
            _transactions = data;
            _error = null;
        } catch (e) {
            _error = 'Failed to load transactions: $e';
        } finally {
            _setLoading(false);
        }
    }
    
    Future<void> refreshTransactions() async {
        try {
            _setLoading(true);
            final data = await repository.getTransactions();
            _transactions = data;
            _error = null;
        } catch (e) {
            _error = 'Failed to refresh transactions: $e';
        } finally {
            _setLoading(false);
        }
    }
    
    void _setLoading(bool value) {
        _loading = value;
        notifyListeners();
    }
    
    void _setError(String? value) {
        _error = value;
        notifyListeners();
    }
}

// Provider setup
final transactionProvider = ChangeNotifierProvider((ref) =>
    TransactionState(
        repository: ref.watch(repositoryProvider),
    ),
);
```

**Verification Steps:**
1. Initialize state with repository
2. Load initial data
3. Test refresh functionality
4. Verify error handling
</details>


## Filter State Implementation

Let's add filter management:

<details>
<summary>View Implementation</summary>

```dart
// lib/features/transactions/presentation/state/filter_state.dart

class FilterState extends ChangeNotifier {
    String? _searchQuery;
    DateTime? _startDate;
    DateTime? _endDate;
    String? _category;
    
    // Getters
    String? get searchQuery => _searchQuery;
    DateTime? get startDate => _startDate;
    DateTime? get endDate => _endDate;
    String? get category => _category;
    
    // Filter setters with validation
    void setSearchQuery(String? query) {
        if (_searchQuery == query) return;
        _searchQuery = query;
        notifyListeners();
    }
    
    void setDateRange(DateTime? start, DateTime? end) {
        if (start != null && end != null && start.isAfter(end)) {
            throw StateError('Start date cannot be after end date');
        }
        _startDate = start;
        _endDate = end;
        notifyListeners();
    }
    
    void setCategory(String? category) {
        if (_category == category) return;
        _category = category;
        notifyListeners();
    }
    
    void clearFilters() {
        _searchQuery = null;
        _startDate = null;
        _endDate = null;
        _category = null;
        notifyListeners();
    }
}

// Provider setup
final filterProvider = ChangeNotifierProvider((ref) => FilterState());
```

**Verification Steps:**
1. Set various filters
2. Test date validation
3. Clear filters
4. Verify notifications
</details>


## Testing Strategy

<details>
<summary>View Test Implementation</summary>

```dart
// test/features/transactions/presentation/state/transaction_state_test.dart

void main() {
    group('TransactionState', () {
        late MockRepository repository;
        late TransactionState state;
        
        setUp(() {
            repository = MockRepository();
            state = TransactionState(repository: repository);
        });
        
        test('loads initial data', () async {
            when(() => repository.getTransactions())
                .thenAnswer((_) async => [
                    Transaction(
                        id: '1',
                        amount: Money(value: 100),
                        description: 'Test',
                        date: DateTime.now(),
                        status: TransactionStatus.completed,
                    ),
                ]);
                
            // Initial load happens in constructor
            await Future.delayed(Duration.zero);
            
            expect(state.loading, false);
            expect(state.transactions.length, 1);
            expect(state.error, null);
        });
        
        test('handles load error', () async {
            when(() => repository.getTransactions())
                .thenThrow(Exception('Network error'));
                
            // Initial load happens in constructor
            await Future.delayed(Duration.zero);
            
            expect(state.loading, false);
            expect(state.transactions, isEmpty);
            expect(state.error, contains('Failed to load'));
        });
    });
}
```
</details>


## Common Issues and Solutions

| Issue | Bad Practice | Good Practice |
|-------|-------------|---------------|
| State Updates | Direct list mutation | Immutable list updates |
| Error Handling | Print statements | Proper error state |
| Loading State | Boolean flags | Centralized loading |
| Notifications | Multiple notifies | Single notify per change |

> 📝 **Note:**  
> Always use immutable state updates to prevent unintended side effects and make state changes more predictable.


## Looking Ahead

In the next lesson (Navigation & Routing), we'll:
- Add navigation state
- Handle deep links
- Protect routes
- Manage navigation history


## Additional Resources

- [Provider Documentation](https://pub.dev/packages/provider)
- [State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [Testing State](https://flutter.dev/docs/cookbook/testing/unit/mocking)
- [Riverpod Documentation](https://riverpod.dev/)

Remember: Proper state management is crucial for building maintainable applications. The time invested in setting up proper state patterns will pay off throughout the development process.
