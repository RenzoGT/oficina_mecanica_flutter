import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oficina_mecanica/viewmodels/vehicle_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/client_viewmodel.dart';
import 'package:oficina_mecanica/models/vehicle.dart';
import 'package:oficina_mecanica/models/client.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleDetailScreen({super.key, this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedClientId;

  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _licensePlateController;
  late TextEditingController _chassisController;
  late TextEditingController _serviceHistoryController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClientViewModel>(context, listen: false).fetchClients();
    });

    _selectedClientId = widget.vehicle?.clientId;

    _modelController = TextEditingController(text: widget.vehicle?.model ?? '');
    _yearController = TextEditingController(
      text: widget.vehicle?.year.toString() ?? '',
    );
    _licensePlateController = TextEditingController(
      text: widget.vehicle?.licensePlate ?? '',
    );
    _chassisController = TextEditingController(
      text: widget.vehicle?.chassis ?? '',
    );
    _serviceHistoryController = TextEditingController(
      text: widget.vehicle?.serviceHistory ?? '',
    );
  }

  @override
  void dispose() {
    _modelController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    _chassisController.dispose();
    _serviceHistoryController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    if (_formKey.currentState!.validate()) {
      final vehicleViewModel = Provider.of<VehicleViewModel>(
        context,
        listen: false,
      );
      final clientViewModel = Provider.of<ClientViewModel>(
        context,
        listen: false,
      );

      final selectedClient = clientViewModel.clients.firstWhere(
        (client) => client.id == _selectedClientId,
      );

      final newVehicle = Vehicle(
        id: (widget.vehicle?.id ?? 0).toString(),
        clientId: _selectedClientId!,
        clientName: selectedClient.name,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        licensePlate: _licensePlateController.text,
        chassis: _chassisController.text,
        serviceHistory: _serviceHistoryController.text,
      );

      if (widget.vehicle == null) {
        vehicleViewModel.addVehicle(newVehicle);
      } else {
        vehicleViewModel.updateVehicle(newVehicle.id, newVehicle);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientViewModel = Provider.of<ClientViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.vehicle == null ? 'Adicionar Veículo' : 'Editar Veículo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (clientViewModel.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (clientViewModel.errorMessage != null)
                Text(
                  'Erro ao carregar clientes: ${clientViewModel.errorMessage}',
                  style: const TextStyle(color: Colors.red),
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedClientId,
                  hint: const Text('Selecione um cliente'),
                  items: clientViewModel.clients.map((Client client) {
                    return DropdownMenuItem<String>(
                      value: client.id,
                      child: Text(client.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedClientId = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Por favor, selecione um cliente' : null,
                ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o modelo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a placa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _chassisController,
                decoration: const InputDecoration(labelText: 'Chassi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o chassi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serviceHistoryController,
                decoration: const InputDecoration(
                  labelText: 'Histórico de Serviços',
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o histórico de serviços';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _saveVehicle,
                child: Text(widget.vehicle == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
