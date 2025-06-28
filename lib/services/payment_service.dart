import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment.dart';

class PaymentService {
  final String baseUrl = "https://oficina-api.vercel.app/api/pagamentos";

  Future<List<Payment>> getPayments() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((payment) => Payment.fromJson(payment)).toList();
    } else {
      throw Exception('Failed to load payments');
    }
  }

  Future<Payment> getPaymentById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load payment');
    }
  }

  Future<Payment> createPayment(Payment payment) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 201) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      try {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        if (errorData.containsKey('error')) {
          throw Exception(errorData['error']);
        }
      } catch (_) {}
      throw Exception(
        'Falha ao registrar o pagamento. ${json.decode(response.body)["error"]}',
      );
    }
  }

  Future<Payment> updatePayment(String id, Payment payment) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(payment.toJson()),
    );

    if (response.statusCode == 200) {
      return Payment.fromJson(json.decode(response.body));
    } else {
      try {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        if (errorData.containsKey('error')) {
          throw Exception(errorData['error']);
        }
      } catch (_) {
        // Fallback
      }
      throw Exception(
        'Falha ao atualizar o pagamento. Status: ${response.statusCode}',
      );
    }
  }

  Future<void> deletePayment(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete payment');
    }
  }

  Future<List<Payment>> getPaymentsByInvoiceId(String invoiceId) async {
    final response = await http.get(Uri.parse('$baseUrl/fatura/$invoiceId'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((payment) => Payment.fromJson(payment)).toList();
    } else {
      throw Exception('Failed to load payments for invoice');
    }
  }
}
