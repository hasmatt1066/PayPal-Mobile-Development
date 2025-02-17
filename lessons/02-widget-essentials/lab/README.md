# Widget Essentials Lab

## Overview
This lab will help you practice essential Flutter widget concepts through hands-on exercises. You'll learn about widget composition, state management, and UI patterns.

## Prerequisites
- Flutter development environment set up
- Completion of Flutter Foundations lab
- Understanding of basic widget concepts

## Exercise 1: Custom Button Widget

### Objective
Create a reusable custom button widget with different states and animations for a financial application.

### Steps to Complete

1. Navigate to the starter code:
```bash
cd starter/lib
```

2. Open `exercise1.dart` in your editor. You'll find:
- A basic `PaymentButton` widget structure
- TODO comments indicating where to add code
- Helper classes for animations

3. Implement the `PaymentButton` widget:
   - Add loading, disabled, and pressed states
   - Implement ripple animation
   - Handle different button styles
   - Add proper accessibility support

4. Test your implementation:
```dart
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: PaymentButton(
            label: 'Send Payment',
            onPressed: () {
              print('Button pressed');
            },
            isLoading: false,
            style: PaymentButtonStyle.primary,
          ),
        ),
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
testWidgets('shows loading indicator', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PaymentButton(
        label: 'Send',
        onPressed: () {},
        isLoading: true,
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(find.text('Send'), findsNothing);
});

testWidgets('handles disabled state', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: PaymentButton(
        label: 'Send',
        onPressed: null,
        isLoading: false,
      ),
    ),
  );

  final button = tester.widget<MaterialButton>(
    find.byType(MaterialButton),
  );
  expect(button.enabled, false);
});
```

3. Manual Testing:
   - Run the app: `flutter run`
   - Test button press animations
   - Verify loading state
   - Check disabled state appearance
   - Test different button styles
   - Verify accessibility features

### Common Issues and Solutions

1. Loading State
```dart
// Wrong:
if (isLoading) {
  return CircularProgressIndicator();
}

// Right:
Stack(
  alignment: Alignment.center,
  children: [
    if (isLoading)
      const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
    else
      Text(label),
  ],
)
```

2. Ripple Effect
```dart
// Wrong:
MaterialButton(
  onPressed: onPressed,
  child: Text(label),
)

// Right:
Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(8),
    child: Ink(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Text(label),
      ),
    ),
  ),
)
```

3. Accessibility
```dart
// Wrong:
GestureDetector(
  onTap: onPressed,
  child: Text(label),
)

// Right:
Semantics(
  button: true,
  enabled: onPressed != null,
  label: semanticsLabel ?? label,
  child: ExcludeSemantics(
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(label),
    ),
  ),
)
```

### Completion Checklist

- [ ] Button shows proper loading state
- [ ] Disabled state is handled correctly
- [ ] Ripple animation works
- [ ] Different styles are implemented
- [ ] Accessibility is properly configured
- [ ] All tests pass
- [ ] Code is properly formatted and documented

### Additional Resources

- [Material Buttons](https://api.flutter.dev/flutter/material/MaterialButton-class.html)
- [Animations Guide](https://flutter.dev/docs/development/ui/animations)
- [Accessibility](https://flutter.dev/docs/development/accessibility-and-localization/accessibility)
- [Widget Testing](https://flutter.dev/docs/cookbook/testing/widget/introduction)

## Next Steps

Once you've completed Exercise 1:
1. Review the solution code in `solution/lib/exercise1.dart`
2. Compare your implementation with the solution
3. Note any differences in approach
4. Move on to Exercise 2

Remember: Focus on understanding the widget lifecycle and state management concepts. Take time to experiment with different widget compositions and understand how they affect performance and user experience.
