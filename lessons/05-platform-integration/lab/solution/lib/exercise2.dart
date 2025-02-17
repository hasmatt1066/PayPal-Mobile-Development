import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'services/loggers.dart';

// Exercise 2: Secure Storage
// Implementation of secure storage across platforms

// Encryption service implementation
class EncryptionService {
  final _key = Key.fromLength(32);
  final _iv = IV.fromLength(16);
  late final _encrypter = Encrypter(AES(_key));

  Future<String> encrypt(String value) async {
    final encrypted = _encrypter.encrypt(value, iv: _iv);
    return encrypted.base64;
  }

  Future<String> decrypt(String value) async {
    final encrypted = Encrypted.fromBase64(value);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }
}

// Secure storage implementation
class SecureStorage {
  final FlutterSecureStorage _storage;
  final EncryptionService _encryption;
  final StorageLogger _logger;
  
  SecureStorage({
    required FlutterSecureStorage storage,
    required EncryptionService encryption,
    required StorageLogger logger,
  }) : _storage = storage,
       _encryption = encryption,
       _logger = logger;
  
  Future<void> saveSecureData(
    String key,
    String value,
  ) async {
    try {
      // Encrypt data
      final encrypted = await _encryption.encrypt(value);
      
      // Use platform options
      await _storage.write(
        key: key,
        value: encrypted,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      
      // Log operation
      await _logger.logStorage(
        'save',
        key,
      );
      
    } catch (e) {
      await _logger.logError(
        'Save failed: $e',
        key,
      );
      rethrow;
    }
  }
  
  Future<String?> getSecureData(String key) async {
    try {
      // Read with platform options
      final encrypted = await _storage.read(
        key: key,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions(),
      );
      
      if (encrypted == null) return null;
      
      // Decrypt data
      final decrypted = await _encryption.decrypt(encrypted);
      
      // Log access
      await _logger.logStorage(
        'read',
        key,
      );
      
      return decrypted;
      
    } catch (e) {
      await _logger.logError(
        'Read failed: $e',
        key,
      );
      rethrow;
    }
  }
  
  IOSOptions _getIOSOptions() => const IOSOptions(
    accessibility: KeychainAccessibility.whenUnlockedThisDeviceOnly,
    synchronizable: false,
  );
  
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
}

// Settings model
class UserSettings {
  final String theme;
  final bool notificationsEnabled;
  final String currency;
  final String language;

  const UserSettings({
    required this.theme,
    required this.notificationsEnabled,
    required this.currency,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'notifications_enabled': notificationsEnabled,
      'currency': currency,
      'language': language,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      theme: json['theme'] as String,
      notificationsEnabled: json['notifications_enabled'] as bool,
      currency: json['currency'] as String,
      language: json['language'] as String,
    );
  }
}

// Settings screen implementation
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = SecureStorage(
    storage: const FlutterSecureStorage(),
    encryption: EncryptionService(),
    logger: StorageLogger(),
  );

  UserSettings _settings = const UserSettings(
    theme: 'light',
    notificationsEnabled: true,
    currency: 'USD',
    language: 'en',
  );

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final data = await _storage.getSecureData('user_settings');
      if (data != null) {
        setState(() {
          _settings = UserSettings.fromJson(
            jsonDecode(data),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load settings: $e')),
        );
      }
    }
  }

  Future<void> _saveSettings(UserSettings settings) async {
    try {
      await _storage.saveSecureData(
        'user_settings',
        jsonEncode(settings.toJson()),
      );
      setState(() => _settings = settings);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildThemeSection(),
          const Divider(),
          _buildNotificationsSection(),
          const Divider(),
          _buildCurrencySection(),
          const Divider(),
          _buildLanguageSection(),
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
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
          selected: {_settings.theme},
          onSelectionChanged: (selected) {
            _saveSettings(
              UserSettings(
                theme: selected.first,
                notificationsEnabled: _settings.notificationsEnabled,
                currency: _settings.currency,
                language: _settings.language,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return SwitchListTile(
      title: const Text('Notifications'),
      subtitle: const Text('Enable push notifications'),
      value: _settings.notificationsEnabled,
      onChanged: (value) {
        _saveSettings(
          UserSettings(
            theme: _settings.theme,
            notificationsEnabled: value,
            currency: _settings.currency,
            language: _settings.language,
          ),
        );
      },
    );
  }

  Widget _buildCurrencySection() {
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
          value: _settings.currency,
          items: const [
            DropdownMenuItem(value: 'USD', child: Text('US Dollar')),
            DropdownMenuItem(value: 'EUR', child: Text('Euro')),
            DropdownMenuItem(value: 'GBP', child: Text('British Pound')),
          ],
          onChanged: (value) {
            if (value != null) {
              _saveSettings(
                UserSettings(
                  theme: _settings.theme,
                  notificationsEnabled: _settings.notificationsEnabled,
                  currency: value,
                  language: _settings.language,
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
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
          value: _settings.language,
          items: const [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'es', child: Text('Spanish')),
            DropdownMenuItem(value: 'fr', child: Text('French')),
          ],
          onChanged: (value) {
            if (value != null) {
              _saveSettings(
                UserSettings(
                  theme: _settings.theme,
                  notificationsEnabled: _settings.notificationsEnabled,
                  currency: _settings.currency,
                  language: value,
                ),
              );
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
    return MaterialApp(
      title: 'Platform Integration Lab - Exercise 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SettingsScreen(),
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
