import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oficina_mecanica/viewmodels/client_viewmodel.dart';
import 'package:oficina_mecanica/models/client.dart';

class ClientDetailScreen extends StatefulWidget {
  final Client? client;

  const ClientDetailScreen({super.key, this.client});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.client?.name ?? '');
    _addressController = TextEditingController(
      text: widget.client?.address ?? '',
    );
    _phoneController = TextEditingController(text: widget.client?.phone ?? '');
    _emailController = TextEditingController(text: widget.client?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveClient() {
    if (_formKey.currentState!.validate()) {
      final clientViewModel = Provider.of<ClientViewModel>(
        context,
        listen: false,
      );
      final newClient = Client(
        id: (widget.client?.id ?? '')
            .toString(),
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      if (widget.client == null) {
        clientViewModel.addClient(newClient);
      } else {
        clientViewModel.updateClient(newClient.id, newClient);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.client == null ? 'Adicionar Cliente' : 'Editar Cliente',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Endereço'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o endereço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveClient,
                child: Text(widget.client == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
