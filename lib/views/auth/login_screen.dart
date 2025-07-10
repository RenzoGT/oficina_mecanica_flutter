// lib/views/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:oficina_mecanica/viewmodels/auth_viewmodel.dart';
import 'package:oficina_mecanica/views/auth/register_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // A função _submit agora não precisa mais do context.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // A lógica de mostrar o SnackBar foi movida para o build.
    // O ViewModel cuidará do resto.
    await Provider.of<AuthViewModel>(context, listen: false).login(
      _emailController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um Consumer para reagir às mudanças e ter acesso ao context correto.
    return Scaffold(
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          // Lógica para mostrar o SnackBar se houver uma mensagem de erro.
          // Usamos um listener de estado aqui.
          if (authViewModel.errorMessage != null && !authViewModel.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dados de login inválidos'),
                  backgroundColor: Colors.red,
                ),
              );
              // Limpa a mensagem de erro para não ser mostrada novamente.
              authViewModel.clearErrorMessage();
            });
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.car_repair, size: 80, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      'Bem-vindo à Oficina',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || !value.contains('@'))
                          ? 'Por favor, insira um email válido.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (value) => (value == null || value.length < 6)
                          ? 'A senha deve ter pelo menos 6 caracteres.'
                          : null,
                    ),
                    const SizedBox(height: 24),
                    authViewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _submit,
                            child: const Text('Entrar'),
                          ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ));
                      },
                      child: const Text('Não tem uma conta? Registre-se'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
