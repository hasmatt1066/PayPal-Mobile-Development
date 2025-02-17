# Platform Integration Lab

## Overview
This lab will help you implement secure platform integration features in Flutter. You'll work with biometric authentication, secure storage, and push notifications while ensuring proper security measures.

## Prerequisites
- Flutter development environment set up
- Completion of Navigation & Routing lab
- Understanding of platform-specific features
- Familiarity with security best practices

## Exercise 1: Biometric Authentication

### Objective
Implement secure biometric authentication with proper error handling and audit logging.

### Steps to Complete

1. Navigate to the starter code:
```bash
cd starter/lib
```

2. Open `exercise1.dart` in your editor. You'll find:
- A basic `BiometricService` class structure
- TODO comments indicating where to add code
- Helper services and loggers

3. Implement the `BiometricService` class:
   - Add biometric authentication
   - Implement fallback mechanisms
   - Add audit logging
   - Handle platform differences

4. Test your implementation:
```dart
void main() {
  runApp(
    MaterialApp(
      home: Builder(
        builder: (context) {
          final service = BiometricService(
            auth: LocalAuthentication(),
            storage: SecureStorage(),
            logger: BiometricLogger(),
          );
          
          return BiometricScreen(service: service);
        },
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
testWidgets('handles biometric authentication', (tester) async {
  final service = BiometricService(
    auth: MockLocalAuthentication(canAuthenticate: true),
    storage: MockSecureStorage(),
    logger: MockBiometricLogger(),
  );
  
  final authenticated = await service.authenticate(
    reason: 'Test authentication',
    action: 'test',
  );
  
  expect(authenticated, isTrue);
});

testWidgets('handles unavailable biometrics', (tester) async {
  final service = BiometricService(
    auth: MockLocalAuthentication(canAuthenticate: false),
    storage: MockSecureStorage(),
    logger: MockBiometricLogger(),
  );
  
  final authenticated = await service.authenticate(
    reason: 'Test authentication',
    action: 'test',
  );
  
  expect(authenticated, isFalse);
});
```

3. Manual Testing:
   - Run the app: `flutter run`
   - Test biometric authentication
   - Verify fallback mechanisms
   - Check error handling
   - Test platform differences

### Common Issues and Solutions

1. Platform Checks
```dart
// Wrong:
if (Platform.isIOS) {
  // iOS-specific code
}

// Right:
if (!await _auth.canCheckBiometrics) {
  await _logger.logError(
    'Biometrics not available',
    action,
  );
  return false;
}

final biometrics = await _auth.getAvailableBiometrics();
if (biometrics.isEmpty) {
  await _logger.logError(
    'No biometrics enrolled',
    action,
  );
  return false;
}
```

2. Authentication Options
```dart
// Wrong:
await _auth.authenticate(
  localizedReason: reason,
);

// Right:
await _auth.authenticate(
  localizedReason: reason,
  options: const AuthenticationOptions(
    stickyAuth: true,
    biometricOnly: true,
    sensitiveTransaction: true,
  ),
);
```

3. Error Handling
```dart
// Wrong:
try {
  return await _auth.authenticate(
    localizedReason: reason,
  );
} catch (e) {
  print(e);
  return false;
}

// Right:
try {
  final authenticated = await _auth.authenticate(
    localizedReason: reason,
    options: const AuthenticationOptions(
      stickyAuth: true,
      biometricOnly: true,
      sensitiveTransaction: true,
    ),
  );
  
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
```

### Completion Checklist

- [ ] Biometric authentication works
- [ ] Fallback mechanisms are implemented
- [ ] Platform differences are handled
- [ ] Audit logging is in place
- [ ] Error handling is robust
- [ ] All tests pass
- [ ] Code is properly formatted and documented

### Additional Resources

- [Local Auth Plugin](https://pub.dev/packages/local_auth)
- [Platform Integration Guide](https://flutter.dev/docs/development/platform-integration)
- [Error Handling](https://dart.dev/guides/libraries/library-tour#handling-errors)
- [Testing Platform Code](https://flutter.dev/docs/testing#platform-integration-tests)

## Next Steps

Once you've completed Exercise 1:
1. Review the solution code in `solution/lib/exercise1.dart`
2. Compare your implementation with the solution
3. Note any differences in approach
4. Move on to Exercise 2

Remember: Security is paramount when working with platform features. Take time to understand the security implications of each platform integration and how to properly protect sensitive operations.
