// lib/viewmodels/auth_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthViewModel() {
    _loadUserFromSession();
  }

  Future<void> _loadUserFromSession() async {
    _isLoading = true;
    notifyListeners();
    _user = await _authService.getUserSession();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.login(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String nomeCompleto) async {
     _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.register(email: email, password: password, nomeCompleto: nomeCompleto);
      _errorMessage = "Registro bem-sucedido! Verifique seu e-mail para confirmar.";
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
  
   void clearErrorMessage() {
    _errorMessage = null;
  }
}
