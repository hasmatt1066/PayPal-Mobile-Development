# Navigation and Routing Lab

## Overview
This lab will help you implement secure navigation patterns in Flutter. You'll learn how to protect routes, handle deep links, and manage navigation state securely.

## Prerequisites
- Flutter development environment set up
- Completion of State Management lab
- Understanding of navigation concepts
- Familiarity with authentication flows

## Exercise 1: Secure Navigation

### Objective
Implement a secure navigation system with proper authentication, authorization, and audit logging.

### Steps to Complete

1. Navigate to the starter code:
```bash
cd starter/lib
```

2. Open `exercise1.dart` in your editor. You'll find:
- A basic `SecureNavigator` class structure
- TODO comments indicating where to add code
- Helper services and models

3. Implement the `SecureNavigator` class:
   - Add authentication checks
   - Implement authorization rules
   - Add audit logging
   - Handle navigation errors

4. Test your implementation:
```dart
void main() {
  runApp(
    MaterialApp(
      home: Builder(
        builder: (context) {
          final navigator = SecureNavigator(
            context: context,
            auth: AuthService(),
            logger: NavigationLogger(),
          );
          
          return HomeScreen(navigator: navigator);
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
testWidgets('requires authentication for secure routes', (tester) async {
  final auth = MockAuthService(isAuthenticated: false);
  final logger = MockNavigationLogger();
  
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          final navigator = SecureNavigator(
            context: context,
            auth: auth,
            logger: logger,
          );
          
          return HomeScreen(navigator: navigator);
        },
      ),
    ),
  );
  
  await tester.tap(find.text('Go to Account'));
  await tester.pumpAndSettle();
  
  expect(find.byType(LoginScreen), findsOneWidget);
});

testWidgets('handles session expiry', (tester) async {
  final auth = MockAuthService(
    isAuthenticated: true,
    isSessionExpired: true,
  );
  
  await tester.pumpWidget(/* ... */);
  
  await tester.tap(find.text('Go to Account'));
  await tester.pumpAndSettle();
  
  expect(find.byType(SessionExpiredDialog), findsOneWidget);
});
```

3. Manual Testing:
   - Run the app: `flutter run`
   - Test protected routes
   - Verify authentication flow
   - Check session handling
   - Test error scenarios

### Common Issues and Solutions

1. Authentication Checks
```dart
// Wrong:
if (!isAuthenticated) {
  Navigator.pushNamed(context, '/login');
  return;
}

// Right:
if (!await auth.isAuthenticated()) {
  await logger.logAccess('Unauthorized access attempt to $route');
  await auth.setRedirectPath(route);
  await navigateTo('/login');
  return;
}
```

2. Session Handling
```dart
// Wrong:
if (sessionExpired) {
  showDialog(context: context, builder: (_) => SessionExpiredDialog());
}

// Right:
if (await auth.isSessionExpired()) {
  await logger.logError('Session expired');
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const SessionExpiredDialog(),
  );
  
  if (result == true) {
    await navigateTo('/login');
  }
}
```

3. Error Recovery
```dart
// Wrong:
try {
  await navigator.pushNamed(route);
} catch (e) {
  print(e);
}

// Right:
try {
  await logger.logNavigation(route);
  await navigateTo(route, arguments: arguments);
} catch (e) {
  await logger.logError('Navigation failed', e);
  _showError('Navigation failed');
}
```

### Completion Checklist

- [ ] Authentication checks are implemented
- [ ] Session handling works correctly
- [ ] Authorization rules are enforced
- [ ] Audit logging is in place
- [ ] Error handling is robust
- [ ] All tests pass
- [ ] Code is properly formatted and documented

### Additional Resources

- [Navigation Guide](https://flutter.dev/docs/development/ui/navigation)
- [Route Management](https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments)
- [Error Handling](https://dart.dev/guides/libraries/library-tour#handling-errors)
- [Testing Navigation](https://flutter.dev/docs/cookbook/testing/navigation)

## Next Steps

Once you've completed Exercise 1:
1. Review the solution code in `solution/lib/exercise1.dart`
2. Compare your implementation with the solution
3. Note any differences in approach
4. Move on to Exercise 2

Remember: Security is critical in financial applications. Take time to understand how navigation affects the security of your app and how to properly protect sensitive routes.
