import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'services/loggers.dart';

// Exercise 1: Biometric Authentication
// Implementation of secure biometric authentication

// Secure storage implementation
class SecureStorage {
  final _storage = const FlutterSecureStorage();
  final StorageLogger _logger;

  SecureStorage({
    required StorageLogger logger,
  }) : _logger = logger;

  Future<String?> getBiometricHash() async {
    try {
      final hash = await _storage.read(key: 'biometric_hash');
      await _logger.logStorage('read', 'biometric_hash');
      return hash;
    } catch (e) {
      await _logger.logError('Failed to read hash', 'biometric_hash');
      return null;
    }
  }

  Future<void> setBiometricHash(String hash) async {
    try {
      await _storage.write(
        key: 'biometric_hash',
        value: hash,
      );
      await _logger.logStorage('write', 'biometric_hash');
    } catch (e) {
      await _logger.logError('Failed to write hash', 'biometric_hash');
    }
  }
}

// Biometric service implementation
class BiometricService {
  final LocalAuthentication _auth;
  final SecureStorage _storage;
  final BiometricLogger _logger;
  
  const BiometricService({
    required LocalAuthentication auth,
    required SecureStorage storage,
    required BiometricLogger logger,
  }) : _auth = auth,
       _storage = storage,
       _logger = logger;
  
  Future<bool> authenticate({
    required String reason,
    required String action,
  }) async {
    try {
      // Check availability
      if (!await _auth.canCheckBiometrics) {
        await _logger.logError(
          'Biometrics not available',
          action,
        );
        return false;
      }

      // Get available methods
      final biometrics = await _auth.getAvailableBiometrics();
      if (biometrics.isEmpty) {
        await _logger.logError(
          'No biometrics enrolled',
          action,
        );
        return false;
      }

      // Authenticate with options
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          sensitiveTransaction: true,
        ),
      );

      // Log result
      await _logger.logAuthentication(
        action,
        authenticated,
      );

      return authenticated;

    } catch (e) {
      await _logger.logError(
        'Authentication failed: $e',
        action,
      );
      return false;
    }
  }

  Future<bool> verifyTransaction(
    Transaction transaction,
  ) async {
    try {
      // Get stored hash
      final storedHash = await _storage.getBiometricHash();
      if (storedHash == null) {
        await _logger.logError(
          'No biometric hash found',
          'verify_transaction',
        );
        return false;
      }

      // Verify biometric
      final authenticated = await authenticate(
        reason: 'Verify transaction of \$${transaction.amount}',
        action: 'verify_transaction',
      );

      if (!authenticated) return false;

      // Verify hash
      final currentHash = await _generateBiometricHash();
      return currentHash == storedHash;

    } catch (e) {
      await _logger.logError(
        'Transaction verification failed: $e',
        'verify_transaction',
      );
      return false;
    }
  }

  Future<String> _generateBiometricHash() async {
    final biometrics = await _auth.getAvailableBiometrics();
    final deviceId = await _getDeviceId();
    final data = utf8.encode('$biometrics-$deviceId');
    return sha256.convert(data).toString();
  }

  Future<String> _getDeviceId() async {
    // In a real app, use platform-specific device ID
    return 'test-device-id';
  }
}

// Transaction model
class Transaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;

  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
  });
}

// Biometric screen implementation
class BiometricScreen extends StatelessWidget {
  const BiometricScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = BiometricService(
      auth: LocalAuthentication(),
      storage: SecureStorage(
        logger: StorageLogger(),
      ),
      logger: BiometricLogger(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final authenticated = await service.authenticate(
                  reason: 'Verify your identity',
                  action: 'login',
                );

                if (authenticated && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TransactionVerificationScreen(
                        transaction: Transaction(
                          id: 'TXN-123',
                          amount: 1000.0,
                          description: 'Test Transaction',
                          date: null,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Authenticate'),
            ),
          ],
        ),
      ),
    );
  }
}

// Transaction verification screen implementation
class TransactionVerificationScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionVerificationScreen({
    required this.transaction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final service = BiometricService(
      auth: LocalAuthentication(),
      storage: SecureStorage(
        logger: StorageLogger(),
      ),
      logger: BiometricLogger(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Transaction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Transaction Amount: \$${transaction.amount}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'Description: ${transaction.description}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final verified = await service.verifyTransaction(transaction);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        verified
                            ? 'Transaction verified'
                            : 'Transaction verification failed',
                      ),
                      backgroundColor: verified ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Verify Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

// Main app widget for testing
class Exercise1App extends StatelessWidget {
  const Exercise1App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform Integration Lab - Exercise 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BiometricScreen(),
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
