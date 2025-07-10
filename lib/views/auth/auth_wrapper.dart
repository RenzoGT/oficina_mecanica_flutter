// lib/views/auth/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:oficina_mecanica/viewmodels/auth_viewmodel.dart';
import 'package:oficina_mecanica/views/auth/login_screen.dart';
import 'package:oficina_mecanica/views/home_page.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    if (authViewModel.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (authViewModel.isAuthenticated) {
      return const HomePage();
    } else {
      return const LoginScreen();
    }
  }
}
