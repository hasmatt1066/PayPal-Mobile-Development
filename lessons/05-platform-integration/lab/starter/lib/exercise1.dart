import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'services/loggers.dart';

// Exercise 1: Biometric Authentication
// Implement secure biometric authentication

// TODO: Implement secure storage
class SecureStorage {
  Future<String?> getBiometricHash() async {
    // TODO: Implement biometric hash retrieval
    return null;
  }

  Future<void> setBiometricHash(String hash) async {
    // TODO: Implement biometric hash storage
  }
}

// TODO: Implement biometric service
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
  
  // TODO: Add authentication methods
  Future<bool> authenticate({
    required String reason,
    required String action,
  }) async {
    // TODO: Implement authentication
    return false;
  }
  
  // TODO: Add platform-specific handling
  Future<bool> verifyTransaction(
    Transaction transaction,
  ) async {
    // TODO: Implement transaction verification
    return false;
  }
  
  // TODO: Add hash generation
  Future<String> _generateBiometricHash() async {
    // TODO: Implement hash generation
    return '';
  }
}

// Example transaction model
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

// Example biometric screen
class BiometricScreen extends StatelessWidget {
  const BiometricScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement biometric UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add biometric UI elements
          ],
        ),
      ),
    );
  }
}

// Example transaction verification screen
class TransactionVerificationScreen extends StatelessWidget {
  final Transaction transaction;

  const TransactionVerificationScreen({
    required this.transaction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement verification UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Transaction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add verification UI elements
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
      ),
      home: const BiometricScreen(),
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
