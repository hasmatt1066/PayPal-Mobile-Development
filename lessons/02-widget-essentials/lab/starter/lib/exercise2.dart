import 'package:flutter/material.dart';

// Exercise 2: Responsive Form Layout
// Implement a responsive payment form that adapts to different screen sizes

class PaymentForm extends StatelessWidget {
  const PaymentForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement responsive layout using LayoutBuilder
    // Hint: Check constraints.maxWidth to determine layout
    return Container();
  }

  // TODO: Implement wide layout (two columns)
  Widget _buildWideLayout() {
    return Container();
  }

  // TODO: Implement narrow layout (single column)
  Widget _buildNarrowLayout() {
    return Container();
  }
}

// Example payment details section
class PaymentDetails extends StatelessWidget {
  const PaymentDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement payment details section
    // Hint: Show amount, description, and payment method
    return Container();
  }
}

// Example payment summary section
class PaymentSummary extends StatelessWidget {
  const PaymentSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement payment summary section
    // Hint: Show subtotal, fees, and total
    return Container();
  }
}

// Main app widget for testing
class Exercise2App extends StatelessWidget {
  const Exercise2App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Essentials Lab - Exercise 2',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Responsive Payment Form'),
        ),
        body: const PaymentForm(),
      ),
    );
  }
}

void main() {
  runApp(const Exercise2App());
}
