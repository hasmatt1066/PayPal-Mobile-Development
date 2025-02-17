# Navigation and Routing in Flutter

**Time Required:** 90 minutes

**Learning Objectives:** By the end of this lesson, engineers will be able to:
- Implement secure navigation patterns for financial applications
- Protect routes with proper authentication and authorization
- Handle deep links securely with parameter validation
- Manage navigation state and session timeouts
- Apply proper audit logging for navigation events


## Prerequisites
- Flutter SDK installed (version 3.0+)
- Basic understanding of Flutter widgets
- Completion of Flutter Foundations lesson


## Development Environment Setup
**Time Required:** 10 minutes

### Project Navigation
1. Navigate to this lesson's directory:
   ```bash
   cd lessons/04-navigation-routing/lab/starter
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
Secure navigation is crucial for financial applications to protect sensitive data and ensure proper access control. This lesson explores implementing robust navigation patterns with security at their core.

> 💡 **Key Concept:**  
> Every navigation event in a financial application must be authenticated, authorized, and properly logged to maintain security and audit compliance.


## Lesson Roadmap

### 1. Navigation Fundamentals (20 min)
- Navigation patterns
- Route protection
- Session management

### 2. Secure Navigation Implementation (25 min)
- Authentication guards
- Authorization checks
- Audit logging

### 3. Deep Link Security (25 min)
- Link validation
- Parameter sanitization
- Security considerations

### 4. Testing & Validation (20 min)
- Navigation testing
- Security verification
- Performance testing


## Navigation Security

Financial applications require secure navigation patterns:

### 1. Route Protection
- Authentication checks
- Authorization rules
- Session validation

### 2. Deep Link Security
- Link validation
- Parameter sanitization
- Authentication handling

### 3. Audit Requirements
- Navigation logging
- Access tracking
- Error reporting

> ⚠️ **Warning:**  
> Never allow direct navigation to sensitive routes without proper authentication and authorization checks.


## Navigation Patterns

Let's explore secure navigation implementations:

### Secure Navigator

```dart
// Secure navigation service with authentication and logging
class SecureNavigator {
    final BuildContext context;
    final AuthService auth;
    final NavigationLogger logger;
    
    const SecureNavigator({
        required this.context,
        required this.auth,
        required this.logger,
    });
    
    Future<void> navigateToSecure(
        String route, {
        Object? arguments,
        bool requireAuth = true,
    }) async {
        try {
            // Verify authentication
            if (requireAuth && !await auth.isAuthenticated()) {
                auth.setRedirectPath(route);
                await navigateTo('/login');
                return;
            }
            
            // Check session expiry
            if (requireAuth && await auth.isSessionExpired()) {
                await _handleSessionExpired();
                return;
            }
            
            // Log navigation attempt
            await logger.logNavigation(route);
            
            // Perform navigation
            await navigateTo(route, arguments: arguments);
            
        } catch (e) {
            await logger.logError('Navigation failed', e);
            _showError('Navigation failed');
        }
    }
    
    Future<void> _handleSessionExpired() async {
        await showDialog(
            context: context,
            builder: (_) => SessionExpiredDialog(),
        );
        
        await navigateTo('/login');
    }
}
```

### Route Guards

```dart
// Authentication guard with logging and error handling
class AuthGuard extends RouteGuard {
    final AuthService auth;
    final NavigationLogger logger;
    
    const AuthGuard({
        required this.auth,
        required this.logger,
    });
    
    @override
    Future<bool> canActivate(
        BuildContext context,
        String route,
    ) async {
        try {
            // Check authentication
            if (!await auth.isAuthenticated()) {
                await _handleUnauthorized(context, route);
                return false;
            }
            
            // Verify session
            if (await auth.isSessionExpired()) {
                await _handleSessionExpired(context);
                return false;
            }
            
            // Check permissions
            if (!await auth.hasPermission(route)) {
                await _handleForbidden(context);
                return false;
            }
            
            // Log successful access
            await logger.logAccess(route);
            return true;
            
        } catch (e) {
            await logger.logError('Guard check failed', e);
            return false;
        }
    }
}
```

> 💡 **Pro Tip:**  
> Implement route guards at both the navigator and route levels for defense in depth.


## Implementation Walkthrough

Let's implement secure deep link handling:

<details>
<summary>View Implementation</summary>

```dart
// lib/navigation/secure_deep_link_handler.dart

class SecureDeepLinkHandler {
    final AuthService auth;
    final NavigationLogger logger;
    
    const SecureDeepLinkHandler({
        required this.auth,
        required this.logger,
    });
    
    Future<bool> handleLink(Uri uri) async {
        try {
            // Validate URI structure
            if (!isValidDeepLink(uri)) {
                await logger.logError(
                    'Invalid deep link format',
                    uri.toString(),
                );
                return false;
            }
            
            // Sanitize parameters
            final sanitizedPath = sanitizePath(uri.path);
            final sanitizedParams = sanitizeParams(
                uri.queryParameters,
            );
            
            // Check authentication
            if (requiresAuth(sanitizedPath)) {
                if (!await auth.isAuthenticated()) {
                    await _handleUnauthenticatedDeepLink(
                        sanitizedPath,
                        sanitizedParams,
                    );
                    return false;
                }
            }
            
            // Log deep link access
            await logger.logDeepLink(uri.toString());
            
            // Navigate to route
            await navigateToRoute(
                sanitizedPath,
                params: sanitizedParams,
            );
            
            return true;
            
        } catch (e) {
            await logger.logError('Deep link failed', e);
            return false;
        }
    }
    
    bool isValidDeepLink(Uri uri) {
        // Implement validation logic
        return true;
    }
    
    String sanitizePath(String path) {
        // Implement sanitization logic
        return path;
    }
    
    Map<String, String> sanitizeParams(
        Map<String, String> params,
    ) {
        // Implement parameter sanitization
        return params;
    }
}
```

**Verification Steps:**
1. Test deep link validation
2. Verify parameter sanitization
3. Check authentication flow
4. Test error handling
5. Verify audit logging
</details>


## DevTools Analysis Guide

### Widget Inspector
1. Locate Navigator widgets in the tree
2. Verify the nested structure:
   ```
   Navigator
   └─ Route
      └─ [Screen widgets]
         ├─ AppBar
         └─ Body
   ```

### Performance Monitoring

> 📝 **Note:**  
> Monitor navigation performance in the Performance tab to ensure smooth transitions and proper error handling.

#### Common Issues and Solutions

| Issue | Bad Practice | Good Practice |
|-------|-------------|---------------|
| Auth Checks | Checking after navigation | Guard-based prevention |
| Deep Links | Direct parameter use | Sanitized parameters |
| Session Handling | Manual timeout checks | Centralized session management |


## Testing Strategy

<details>
<summary>View Test Implementation</summary>

```dart
// test/navigation/secure_navigator_test.dart

void main() {
    group('SecureNavigator', () {
        late MockAuthService auth;
        late MockNavigationLogger logger;
        late SecureNavigator navigator;
        
        setUp(() {
            auth = MockAuthService();
            logger = MockNavigationLogger();
            navigator = SecureNavigator(
                auth: auth,
                logger: logger,
            );
        });
        
        test('requires authentication for secure routes', () async {
            when(() => auth.isAuthenticated())
                .thenAnswer((_) async => false);
                
            await navigator.navigateToSecure('/account');
            
            verify(() => navigator.navigateTo('/login')).called(1);
        });
        
        test('handles session expiration', () async {
            when(() => auth.isAuthenticated())
                .thenAnswer((_) async => true);
            when(() => auth.isSessionExpired())
                .thenAnswer((_) async => true);
                
            await navigator.navigateToSecure('/account');
            
            verify(() => navigator.navigateTo('/login')).called(1);
        });
    });
}
```
</details>


## Looking Ahead

In the next lesson, we'll explore:
- Platform integration
- Biometric authentication
- Push notifications
- App deployment


## Additional Resources

- [Navigation Guide](https://flutter.dev/docs/development/ui/navigation)
- [Deep Linking](https://flutter.dev/docs/development/ui/navigation/deep-linking)
- [Route Guards](https://flutter.dev/docs/cookbook/navigation/navigate-with-arguments)
- [Security Best Practices](https://flutter.dev/docs/security)
- [Testing Navigation](https://flutter.dev/docs/cookbook/testing/navigation)
