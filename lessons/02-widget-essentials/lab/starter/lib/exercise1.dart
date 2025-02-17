import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Exercise 1: Secure Payment Input
// Implement a secure and accessible payment input field

class PaymentInputField extends StatefulWidget {
  final void Function(double) onAmountChanged;
  
  const PaymentInputField({
    required this.onAmountChanged,
    Key? key,
  }) : super(key: key);

  @override
  _PaymentInputFieldState createState() => _PaymentInputFieldState();
}

class _PaymentInputFieldState extends State<PaymentInputField> {
  // TODO: Add text controller
  // TODO: Add validation state
  
  @override
  void initState() {
    super.initState();
    // TODO: Initialize controller
  }
  
  @override
  void dispose() {
    // TODO: Clean up controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement secure input field with:
    // - Currency symbol
    // - Input formatting
    // - Real-time validation
    // - Error messages
    // - Screen reader support
    return Container();
  }
  
  // TODO: Implement validation logic
  String? _validateAmount(String? value) {
    return null;
  }
  
  // TODO: Implement amount parsing and formatting
  double? _parseAmount(String value) {
    return null;
  }
}

// Main app widget for testing
class Exercise1App extends StatelessWidget {
  const Exercise1App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget Essentials Lab - Exercise 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Secure Payment Input'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PaymentInputField(
                onAmountChanged: (amount) {
                  print('Amount changed: \$$amount');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Exercise1App());
}
