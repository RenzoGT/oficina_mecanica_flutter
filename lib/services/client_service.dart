import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';

class ClientService {
  final String baseUrl = "https://oficina-api.vercel.app/api/clientes";

  Future<List<Client>> getClients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((client) => Client.fromJson(client)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }

  Future<Client> getClientById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<Client> createClient(Client client) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 201) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create client');
    }
  }

  Future<Client> updateClient(String id, Client client) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(client.toJson()),
    );

    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update client');
    }
  }

  Future<void> deleteClient(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      print('Client deleted successfully');
    } else {
      throw Exception('Failed to delete client');
    }
  }
}
