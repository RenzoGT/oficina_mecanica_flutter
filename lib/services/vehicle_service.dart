import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';

class VehicleService {
  final String baseUrl = "https://oficina-api.vercel.app/api/veiculos";

  Future<List<Vehicle>> getVehicles() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<Vehicle> getVehicleById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Vehicle.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load vehicle');
    }
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode == 201) {
      return Vehicle.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create vehicle');
    }
  }

  Future<Vehicle> updateVehicle(String id, Vehicle vehicle) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(vehicle.toJson()),
    );

    if (response.statusCode == 200) {
      return Vehicle.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update vehicle');
    }
  }

  Future<void> deleteVehicle(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      print('Vehicle deleted successfully');
    } else {
      throw Exception('Failed to delete vehicle');
    }
  }

  Future<List<Vehicle>> getVehiclesByClientId(String clientId) async {
    final response = await http.get(
      Uri.parse(
        'https://oficina-api.vercel.app/api/clientes/$clientId/veiculos',
      ),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } else {
      throw Exception('Failed to load vehicles for client');
    }
  }
}
