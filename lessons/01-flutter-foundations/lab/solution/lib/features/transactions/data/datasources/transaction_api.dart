import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/exceptions/transaction_exception.dart';

// Data layer - API data source
class TransactionApi {
  final String baseUrl;
  final http.Client client;

  TransactionApi({
    required this.baseUrl,
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/transactions'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        throw TransactionException.unauthorized();
      } else {
        throw TransactionException(
          'Failed to fetch transactions',
          code: 'API_ERROR',
          originalError: response.body,
        );
      }
    } on TimeoutException {
      throw TransactionException(
        'Request timed out',
        code: 'TIMEOUT',
      );
    } catch (e) {
      throw TransactionException.networkError(e);
    }
  }

  Future<Map<String, dynamic>> getTransactionById(String id) async {
    try {
      final response = await client
          .get(Uri.parse('$baseUrl/transactions/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        throw TransactionException.notFound(id);
      } else if (response.statusCode == 401) {
        throw TransactionException.unauthorized();
      } else {
        throw TransactionException(
          'Failed to fetch transaction',
          code: 'API_ERROR',
          originalError: response.body,
        );
      }
    } on TimeoutException {
      throw TransactionException(
        'Request timed out',
        code: 'TIMEOUT',
      );
    } catch (e) {
      throw TransactionException.networkError(e);
    }
  }

  Future<Map<String, dynamic>> createTransaction(
      Map<String, dynamic> transaction) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/transactions'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(transaction),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw TransactionException.unauthorized();
      } else {
        throw TransactionException(
          'Failed to create transaction',
          code: 'API_ERROR',
          originalError: response.body,
        );
      }
    } on TimeoutException {
      throw TransactionException(
        'Request timed out',
        code: 'TIMEOUT',
      );
    } catch (e) {
      throw TransactionException.networkError(e);
    }
  }

  // Additional methods for update and delete would follow similar patterns
}
