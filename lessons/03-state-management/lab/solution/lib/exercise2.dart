import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Exercise 2: State Persistence
// Implementation of secure state persistence and recovery

class PersistentState<T> extends StateNotifier<T> {
  final String key;
  final SecureStorage storage;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  bool _initialized = false;

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
      _initialized = true;
    } catch (e) {
      debugPrint('Failed to load state: $e');
      // Keep initial state on error
      _initialized = true;
    }
  }

  @override
  set state(T value) {
    super.state = value;
    _saveState();
  }

  Future<void> _saveState() async {
    if (!_initialized) return;
    
    try {
      final json = toJson(state);
      await storage.write(
        key: key,
        value: jsonEncode(json),
      );
    } catch (e) {
      debugPrint('Failed to save state: $e');
    }
  }

  Future<void> reset() async {
    try {
      await storage.delete(key);
    } catch (e) {
      debugPrint('Failed to reset state: $e');
    }
  }
}

// Secure storage implementation
class SecureStorage {
  final Map<String, String> _storage = {};

  Future<void> write({
    required String key,
    required String value,
  }) async {
    // Simulate encryption and secure storage
    await Future.delayed(const Duration(milliseconds: 100));
    _storage[key] = value;
  }

  Future<String?> read(String key) async {
    // Simulate decryption and secure retrieval
    await Future.delayed(const Duration(milliseconds: 100));
    return _storage[key];
  }

  Future<void> delete(String key) async {
    // Simulate secure deletion
    await Future.delayed(const Duration(milliseconds: 100));
    _storage.remove(key);
  }
}

// User preferences implementation
class UserPreferences extends PersistentState<Map<String, dynamic>> {
  UserPreferences({
    required SecureStorage storage,
  }) : super(
          initial: const {
            'theme': 'light',
            'notifications': true,
            'currency': 'USD',
            'language': 'en',
          },
          key: 'user_preferences',
          storage: storage,
          fromJson: (json) => Map<String, dynamic>.from(json),
          toJson: (state) => state,
        );

  void updateTheme(String theme) {
    if (!_isValidTheme(theme)) {
      throw ArgumentError('Invalid theme: $theme');
    }
    state = {...state, 'theme': theme};
  }

  void updateNotifications(bool enabled) {
    state = {...state, 'notifications': enabled};
  }

  void updateCurrency(String currency) {
    if (!_isValidCurrency(currency)) {
      throw ArgumentError('Invalid currency: $currency');
    }
    state = {...state, 'currency': currency};
  }

  void updateLanguage(String language) {
    if (!_isValidLanguage(language)) {
      throw ArgumentError('Invalid language: $language');
    }
    state = {...state, 'language': language};
  }

  bool _isValidTheme(String theme) => ['light', 'dark'].contains(theme);
  bool _isValidCurrency(String currency) => ['USD', 'EUR', 'GBP'].contains(currency);
  bool _isValidLanguage(String language) => ['en', 'es', 'fr'].contains(language);
}

// Providers
final secureStorageProvider = Provider((ref) => SecureStorage());

final preferencesProvider = StateNotifierProvider<UserPreferences, Map<String, dynamic>>((ref) {
  return UserPreferences(
    storage: ref.watch(secureStorageProvider),
  );
});

// Preferences screen implementation
class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesProvider);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildThemeSection(context, ref, preferences),
        const Divider(),
        _buildNotificationsSection(context, ref, preferences),
        const Divider(),
        _buildCurrencySection(context, ref, preferences),
        const Divider(),
        _buildLanguageSection(context, ref, preferences),
      ],
    );
  }

  Widget _buildThemeSection(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Theme',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'light',
              label: Text('Light'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: 'dark',
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode),
            ),
          ],
          selected: {preferences['theme']},
          onSelectionChanged: (selected) {
            ref.read(preferencesProvider.notifier).updateTheme(selected.first);
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return SwitchListTile(
      title: const Text('Notifications'),
      subtitle: const Text('Enable push notifications'),
      value: preferences['notifications'],
      onChanged: (value) {
        ref.read(preferencesProvider.notifier).updateNotifications(value);
      },
    );
  }

  Widget _buildCurrencySection(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Currency',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: preferences['currency'],
          items: const [
            DropdownMenuItem(value: 'USD', child: Text('US Dollar')),
            DropdownMenuItem(value: 'EUR', child: Text('Euro')),
            DropdownMenuItem(value: 'GBP', child: Text('British Pound')),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(preferencesProvider.notifier).updateCurrency(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, WidgetRef ref, Map<String, dynamic> preferences) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Language',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: preferences['language'],
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'es', child: Text('Spanish')),
            DropdownMenuItem(value: 'fr', child: Text('French')),
          ],
          onChanged: (value) {
            if (value != null) {
              ref.read(preferencesProvider.notifier).updateLanguage(value);
            }
          },
        ),
      ],
    );
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
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('User Preferences'),
          ),
          body: const PreferencesScreen(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
