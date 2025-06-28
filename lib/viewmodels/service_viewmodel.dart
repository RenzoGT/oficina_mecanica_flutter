import 'package:flutter/material.dart';
import '../models/service.dart';
import '../services/service_service.dart';

class ServiceViewModel extends ChangeNotifier {
  final ServiceService _serviceService = ServiceService();
  List<Service> _services = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Service> get services => _services;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _isSlotOccupied(Service serviceToCheck) {
    return _services.any((existingService) {
      if (existingService.id == serviceToCheck.id) {
        return false;
      }
      return existingService.scheduledDate == serviceToCheck.scheduledDate &&
          existingService.scheduledTime == serviceToCheck.scheduledTime;
    });
  }

  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _services = await _serviceService.getServices();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addService(Service service) async {
    if (_isSlotOccupied(service)) {
      _errorMessage = "Já existe um serviço agendado para esta data e hora.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _serviceService.createService(service);
      await fetchServices();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> updateService(String id, Service service) async {
    if (_isSlotOccupied(service)) {
      _errorMessage = "Já existe outro serviço agendado para esta data e hora.";
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _serviceService.updateService(id, service);
      await fetchServices();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> deleteService(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _serviceService.deleteService(id);
      await fetchServices();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
