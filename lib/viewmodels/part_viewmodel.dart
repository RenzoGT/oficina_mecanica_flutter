import 'package:flutter/material.dart';
import '../models/part.dart';
import '../services/part_service.dart';

class PartViewModel extends ChangeNotifier {
  final PartService _partService = PartService();
  List<Part> _parts = [];
  List<Part> _lowStockParts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Part> get parts => _parts;
  List<Part> get lowStockParts => _lowStockParts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchParts() async {
    _isLoading = true;
    _errorMessage = null;
    _lowStockParts.clear();
    notifyListeners();
    try {
      _parts = await _partService.getParts();
      _lowStockParts = _parts
          .where((part) => part.quantity <= part.minLevel)
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPart(Part part) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _partService.createPart(part);
      await fetchParts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePart(String id, Part part) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _partService.updatePart(id, part);
      await fetchParts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePart(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _partService.deletePart(id);
      await fetchParts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePartQuantity(
    String id,
    int quantity,
    String operation,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _partService.updatePartQuantity(id, quantity, operation);
      await fetchParts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
