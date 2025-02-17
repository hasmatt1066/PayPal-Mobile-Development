import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Exercise 2: State Persistence
// Implement secure state persistence and recovery

// TODO: Implement persistent state
class PersistentState<T> extends StateNotifier<T> {
  final String key;
  final SecureStorage storage;
  
  PersistentState({
    required T initial,
    required this.key,
    required this.storage,
  }) : super(initial) {
    // TODO: Load persisted state
  }
  
  // TODO: Implement state persistence
  // TODO: Add error handling
  // TODO: Add data validation
}

// Example secure storage implementation
class SecureStorage {
  Future<void> write({
    required String key,
    required String value,
  }) async {
    // TODO: Implement secure write
  }

  Future<String?> read(String key) async {
    // TODO: Implement secure read
    return null;
  }

  Future<void> delete(String key) async {
    // TODO: Implement secure delete
  }
}

// Example usage
class UserPreferences extends PersistentState<Map<String, dynamic>> {
  UserPreferences({
    required SecureStorage storage,
  }) : super(
          initial: const {'theme': 'light'},
          key: 'user_preferences',
          storage: storage,
        );

  // TODO: Add methods to update preferences
  // TODO: Add data validation
  // TODO: Add error handling
}

// Example preferences screen
class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement preferences UI
    return Container();
  }
}

// Main app widget for testing
class Exercise2App extends StatelessWidget {
  const Exercise2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'State Management Lab - Exercise 2',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Scaffold(
          body: PreferencesScreen(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
