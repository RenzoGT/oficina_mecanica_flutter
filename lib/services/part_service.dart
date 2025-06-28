import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/part.dart';

class PartService {
  final String baseUrl = "https://oficina-api.vercel.app/api/estoque";

  Future<List<Part>> getParts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((part) => Part.fromJson(part)).toList();
    } else {
      throw Exception('Failed to load parts');
    }
  }

  Future<Part> getPartById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Part.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load part');
    }
  }

  Future<Part> createPart(Part part) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(part.toJson()),
    );

    if (response.statusCode == 201) {
      return Part.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create part');
    }
  }

  Future<Part> updatePart(String id, Part part) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(part.toJson()),
    );

    if (response.statusCode == 200) {
      return Part.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update part');
    }
  }

  Future<void> deletePart(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete part');
    }
  }

  Future<void> updatePartQuantity(
    String id,
    int quantity,
    String operation,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id/quantidade'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'quantidade': quantity, 'operacao': operation}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update part quantity');
    }
  }
}
