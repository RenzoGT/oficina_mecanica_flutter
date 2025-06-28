import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:oficina_mecanica/views/service_detail_screen.dart';
import 'package:oficina_mecanica/models/service.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceViewModel>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Serviços Agendados')),
      body: Consumer<ServiceViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          } else if (viewModel.services.isEmpty) {
            return const Center(child: Text('Nenhum serviço agendado.'));
          } else {
            return ListView.builder(
              itemCount: viewModel.services.length,
              itemBuilder: (context, index) {
                final service = viewModel.services[index];
                return ListTile(
                  title: Text(service.serviceType),
                  subtitle: Text(
                    '${service.scheduledDate} - ${service.scheduledTime}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailScreen(service: service),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      viewModel.deleteService(service.id);
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
            MaterialPageRoute(
              builder: (context) => const ServiceDetailScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
