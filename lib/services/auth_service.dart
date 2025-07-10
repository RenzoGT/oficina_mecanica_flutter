// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart'; // Certifique-se de que o modelo AppUser existe

class AuthService {
  final String baseUrl = "https://oficina-api.vercel.app/api/auth";

  Future<AppUser> register({
    required String email,
    required String password,
    required String nomeCompleto,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'nome_completo': nomeCompleto,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return AppUser.fromJson(responseData['user']);
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'Falha ao registrar.');
    }
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final user = AppUser.fromJson(responseData['user']);
      final userWithToken = AppUser(
        id: user.id,
        email: user.email,
        nomeCompleto: user.nomeCompleto,
        accessToken: responseData['accessToken'],
      );

      await _saveUserSession(userWithToken);
      return userWithToken;
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['error'] ?? 'Falha no login.');
    }
  }

  Future<void> _saveUserSession(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(user.toMap());
    await prefs.setString('user_session', userData);
  }

  Future<AppUser?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_session');
    if (userData != null) {
      return AppUser.fromMap(json.decode(userData));
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_session');
  }
}
