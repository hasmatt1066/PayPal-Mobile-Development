# State Management in Flutter

**Time Required:** 120 minutes

**Learning Objectives:** By the end of this lesson, engineers will be able to:
- Implement secure state management patterns for financial data
- Use Provider and Riverpod for scalable state management
- Handle complex state dependencies and synchronization
- Implement secure state persistence and recovery
- Apply proper error handling and audit logging


## Prerequisites
- Flutter SDK installed (version 3.0+)
- Basic understanding of Flutter widgets
- Completion of Flutter Foundations lesson


## Development Environment Setup
**Time Required:** 10 minutes

### Project Navigation
1. Navigate to this lesson's directory:
   ```bash
   cd lessons/03-state-management/lab/starter
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

> 💡 **Pro Tip:**  
> If you closed your IDE since the last lesson, reopen the project:
> - VS Code: `code .`
> - Android Studio: Open the `starter` directory

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
State management in financial applications requires special attention to security, data integrity, and performance. This lesson explores robust patterns for managing sensitive financial data while maintaining a responsive user experience.

> 💡 **Key Concept:**  
> Financial state management must prioritize data security and integrity while providing real-time updates and proper audit logging for all state changes.


## Lesson Roadmap

### 1. State Management Fundamentals (30 min)
- Types of state
- State security considerations
- State persistence patterns

### 2. Provider Pattern Implementation (30 min)
- Basic Provider usage
- Secure state updates
- Error handling

### 3. Complex State Patterns (30 min)
- State dependencies
- State synchronization
- Recovery mechanisms

### 4. Testing & Validation (30 min)
- State testing patterns
- Security verification
- Performance testing


## Types of State

Financial applications manage different types of state:

### 1. Ephemeral State
- Local UI state
- Short-lived data
- No persistence needed

### 2. App State
- User session data
- Transaction history
- Account settings

### 3. Secure State
- Authentication tokens
- Encryption keys
- Sensitive user data

> ⚠️ **Warning:**  
> Never store sensitive financial data in ephemeral state or unencrypted persistent storage.


## State Management Patterns

Let's explore common patterns:

### ChangeNotifier Pattern

```dart
// Basic state holder with security measures
class TransactionState extends ChangeNotifier {
    final List<Transaction> _transactions = [];
    bool _loading = false;
    String? _error;
    
    // Secure getters prevent direct state modification
    UnmodifiableListView<Transaction> get transactions => 
        UnmodifiableListView(_transactions);
    bool get loading => _loading;
    String? get error => _error;
    
    // State updates with error handling and logging
    Future<void> loadTransactions() async {
        try {
            _setLoading(true);
            final data = await api.getTransactions();
            _transactions = data;
            notifyListeners();
        } catch (e) {
            _setError('Failed to load transactions');
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
}
```

### Provider Pattern

```dart
// Provider setup with dependency injection
final transactionProvider = ChangeNotifierProvider((ref) => 
    TransactionState(
        api: ref.watch(apiProvider),
        storage: ref.watch(storageProvider),
    ),
);

// UI consumption with error handling
class TransactionScreen extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final state = ref.watch(transactionProvider);
        
        if (state.loading) {
            return LoadingIndicator();
        }
        
        if (state.error != null) {
            return ErrorView(
                error: state.error!,
                onRetry: () => ref.read(transactionProvider.notifier)
                    .loadTransactions(),
            );
        }
        
        return TransactionList(
            transactions: state.transactions,
        );
    }
}
```

> 💡 **Pro Tip:**  
> Use Provider's dependency injection to manage complex state dependencies and enable easier testing.


## Implementation Walkthrough

Let's implement secure state management for a financial app:

<details>
<summary>View Implementation</summary>

```dart
// lib/state/secure_state.dart

class TransactionState extends ChangeNotifier {
    final SecureStorage _storage;
    final List<Transaction> _transactions = [];
    bool _isLoading = false;
    String? _error;
    
    TransactionState(this._storage) {
        _loadTransactions();
    }
    
    // Prevent direct state modification
    UnmodifiableListView<Transaction> get transactions => 
        UnmodifiableListView(_transactions);
    bool get isLoading => _isLoading;
    String? get error => _error;
    
    Future<void> addTransaction(Transaction transaction) async {
        try {
            _setLoading(true);
            
            // Validate transaction
            if (!transaction.isValid()) {
                throw StateError('Invalid transaction data');
            }
            
            // Add to secure storage
            await _storage.saveTransaction(transaction);
            
            // Update state
            _transactions.insert(0, transaction);
            notifyListeners();
            
            // Log state change
            await _logStateChange('add_transaction', transaction.id);
            
        } catch (e) {
            _setError('Failed to add transaction: $e');
        } finally {
            _setLoading(false);
        }
    }
    
    Future<void> _loadTransactions() async {
        try {
            _setLoading(true);
            
            final stored = await _storage.loadTransactions();
            _transactions.clear();
            _transactions.addAll(stored);
            
            notifyListeners();
            
        } catch (e) {
            _setError('Failed to load transactions: $e');
        } finally {
            _setLoading(false);
        }
    }
}
```

**Verification Steps:**
1. Initialize state with secure storage
2. Add test transactions
3. Verify state updates
4. Test error handling
5. Check audit logging
</details>


## DevTools Analysis Guide

### Widget Inspector
1. Locate Provider widgets in the tree
2. Verify the nested structure:
   ```
   ProviderScope
   └─ TransactionProvider
      └─ Consumer
         └─ TransactionList
            └─ [Transaction widgets]
   ```

### State Persistence

Implement secure state persistence:

<details>
<summary>View Implementation</summary>

```dart
class PersistentState<T> extends StateNotifier<T> {
    final String key;
    final SecureStorage storage;
    final T Function(Map<String, dynamic>) fromJson;
    final Map<String, dynamic> Function(T) toJson;
    
    PersistentState({
        required T initial,
        required this.key,
        required this.storage,
        required this.fromJson,
        required this.toJson,
    }) : super(initial) {
        _loadState();
    }
    
    Future<void> _loadState() async {
        try {
            final data = await storage.read(key);
            if (data != null) {
                final json = jsonDecode(data);
                state = fromJson(json);
            }
        } catch (e) {
            print('Failed to load state: $e');
        }
    }
    
    @override
    set state(T value) {
        super.state = value;
        _saveState();
    }
    
    Future<void> _saveState() async {
        try {
            final json = toJson(state);
            await storage.write(
                key: key,
                value: jsonEncode(json),
            );
        } catch (e) {
            print('Failed to save state: $e');
        }
    }
}
```
</details>


## Testing Strategy

<details>
<summary>View Test Implementation</summary>

```dart
// test/state/transaction_state_test.dart

void main() {
    group('TransactionState', () {
        late MockSecureStorage storage;
        late TransactionState state;
        
        setUp(() {
            storage = MockSecureStorage();
            state = TransactionState(storage);
        });
        
        test('loads transactions securely', () async {
            final transactions = [
                Transaction(id: '1', amount: 100),
                Transaction(id: '2', amount: 200),
            ];
            
            when(() => storage.loadTransactions())
                .thenAnswer((_) async => transactions);
                
            await state.loadTransactions();
            
            expect(state.transactions, transactions);
            expect(state.isLoading, false);
            expect(state.error, null);
        });
        
        test('handles errors properly', () async {
            when(() => storage.loadTransactions())
                .thenThrow(Exception('Storage error'));
                
            await state.loadTransactions();
            
            expect(state.error, isNotNull);
            expect(state.isLoading, false);
            expect(state.transactions, isEmpty);
        });
    });
}
```
</details>


## Looking Ahead

In the next lesson, we'll explore:
- Navigation and routing
- Deep linking
- Screen transitions
- Error recovery flows


## Additional Resources

- [Provider Documentation](https://pub.dev/packages/provider)
- [Riverpod Documentation](https://riverpod.dev/)
- [State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)
- [Testing Guide](https://flutter.dev/docs/testing)
- [Secure Storage Guide](https://flutter.dev/docs/cookbook/persistence/secure-storage)
