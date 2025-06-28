import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/client_service.dart';

class ClientViewModel extends ChangeNotifier {
  final ClientService _clientService = ClientService();
  List<Client> _clients = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Client> get clients => _clients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchClients() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _clients = await _clientService.getClients();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addClient(Client client) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _clientService.createClient(client);
      await fetchClients();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateClient(String id, Client client) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _clientService.updateClient(id, client);
      await fetchClients();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteClient(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _clientService.deleteClient(id);
      await fetchClients();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
