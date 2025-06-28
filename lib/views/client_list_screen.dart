import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oficina_mecanica/viewmodels/client_viewmodel.dart';
import 'package:oficina_mecanica/views/client_detail_screen.dart';
import 'package:oficina_mecanica/models/client.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientViewModel>(context, listen: false).fetchClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: Consumer<ClientViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          } else if (viewModel.clients.isEmpty) {
            return const Center(child: Text('Nenhum cliente cadastrado.'));
          } else {
            return ListView.builder(
              itemCount: viewModel.clients.length,
              itemBuilder: (context, index) {
                final client = viewModel.clients[index];
                return ListTile(
                  title: Text(client.name),
                  subtitle: Text(client.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClientDetailScreen(client: client),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      viewModel.deleteClient(client.id);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClientDetailScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
