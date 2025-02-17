import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Exercise 1: Secure Payment Input
// Implementation of a secure and accessible payment input field

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
  final _controller = TextEditingController();
  String? _error;
  bool _isDirty = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleAmountChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleAmountChanged);
    _controller.dispose();
    super.dispose();
  }

  void _handleAmountChanged() {
    setState(() {
      _isDirty = true;
      _error = _validateAmount(_controller.text);
    });

    if (_error == null) {
      final amount = _parseAmount(_controller.text);
      if (amount != null) {
        widget.onAmountChanged(amount);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'Amount',
            prefixText: '\$',
            border: const OutlineInputBorder(),
            errorText: _isDirty ? _error : null,
            // Accessibility support
            semanticsLabel: 'Payment amount in dollars',
            helperText: 'Enter payment amount',
          ),
          // Format input as currency
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          // Accessibility hints
          textInputAction: TextInputAction.done,
          autofocus: true,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(
            _error!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }

    final amount = _parseAmount(value);
    if (amount == null) {
      return 'Enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than zero';
    }

    if (amount > 10000) {
      return 'Amount cannot exceed \$10,000';
    }

    return null;
  }

  double? _parseAmount(String value) {
    try {
      // Remove any non-numeric characters except decimal point
      final sanitized = value.replaceAll(RegExp(r'[^\d.]'), '');
      return double.parse(sanitized);
    } catch (e) {
      return null;
    }
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
        // High contrast theme for accessibility
        brightness: Brightness.light,
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black87,
          displayColor: Colors.black87,
        ),
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
                  print('Amount changed: \$${amount.toStringAsFixed(2)}');
                },
              ),
              const SizedBox(height: 16),
              // Example of semantic label for screen readers
              Semantics(
                label: 'Payment amount help',
                child: const Text(
                  'Enter the amount you want to send. Maximum amount is \$10,000.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
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
