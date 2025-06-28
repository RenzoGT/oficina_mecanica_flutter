import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/invoice.dart';

class InvoiceService {
  final String baseUrl = "https://oficina-api.vercel.app/api/faturas";

  Future<List<Invoice>> getInvoices() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((invoice) => Invoice.fromJson(invoice)).toList();
    } else {
      throw Exception('Failed to load invoices');
    }
  }

  Future<Invoice> getInvoiceById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Invoice.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load invoice');
    }
  }

  Future<Invoice> createInvoice(Invoice invoice) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(invoice.toJson()),
    );

    if (response.statusCode == 201) {
      return Invoice.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create invoice');
    }
  }

  Future<Invoice> updateInvoice(String id, Invoice invoice) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(invoice.toJson()),
    );

    if (response.statusCode == 200) {
      return Invoice.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update invoice');
    }
  }

  Future<void> deleteInvoice(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      print('Invoice deleted successfully');
    } else {
      throw Exception('Failed to delete invoice');
    }
  }

  Future<List<Invoice>> getOpenInvoices() async {
    final response = await http.get(Uri.parse('$baseUrl/em-aberto'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((invoice) => Invoice.fromJson(invoice)).toList();
    } else {
      throw Exception('Failed to load open invoices');
    }
  }
}
