import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service.dart';

class ServiceService {
  final String baseUrl = "https://oficina-api.vercel.app/api/servicos";

  Future<List<Service>> getServices() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((service) => Service.fromJson(service)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<Service> getServiceById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Service.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load service');
    }
  }

  Future<Service> createService(Service service) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'VeiculoID': service.vehicleId,
        'FuncionarioID': null,
        'DataAgendamento': service.scheduledDate,
        'HoraAgendamento': service.scheduledTime,
        'TipoServico': service.serviceType,
        'Status': service.status,
        'Descricao': service.description,
        'ValorTotal': service.totalValue,
      }),
    );

    if (response.statusCode == 201) {
      return Service.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create service');
    }
  }

  Future<Service> updateService(String id, Service service) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(service.toJson()),
    );

    if (response.statusCode == 200) {
      return Service.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update service');
    }
  }

  Future<void> deleteService(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      print('Service deleted successfully');
    } else {
      throw Exception('Failed to delete service');
    }
  }

  Future<void> addPartToService(
    String serviceId,
    String partId,
    int quantity,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$serviceId/pecas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'PecaID': partId, 'Quantidade': quantity}),
    );

    if (response.statusCode == 200) {
      print('Part added to service successfully');
    } else {
      throw Exception('Failed to add part to service');
    }
  }

  Future<void> removePartFromService(String serviceId, String partId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$serviceId/pecas/$partId'),
    );

    if (response.statusCode == 204) {
      print('Part removed from service successfully');
    } else {
      throw Exception('Failed to remove part from service');
    }
  }
}
