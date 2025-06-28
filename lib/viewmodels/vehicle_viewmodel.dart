import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';

class VehicleViewModel extends ChangeNotifier {
  final VehicleService _vehicleService = VehicleService();
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _vehicles = await _vehicleService.getVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVehiclesByClientId(String clientId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _vehicles = await _vehicleService.getVehiclesByClientId(clientId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _vehicleService.createVehicle(vehicle);
      await fetchVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicle(String id, Vehicle vehicle) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _vehicleService.updateVehicle(id, vehicle);
      await fetchVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _vehicleService.deleteVehicle(id);
      await fetchVehicles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
