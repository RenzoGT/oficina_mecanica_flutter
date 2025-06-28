import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oficina_mecanica/models/service.dart';
import 'package:oficina_mecanica/models/vehicle.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/vehicle_viewmodel.dart';
import 'package:provider/provider.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service? service;

  const ServiceDetailScreen({super.key, this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _statusOptions = [
    'Agendado',
    'Em Andamento',
    'Concluido',
    'Cancelado',
  ];

  String? _selectedVehicleId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedStatus;

  late TextEditingController _employeeIdController;
  late TextEditingController _scheduledDateController;
  late TextEditingController _scheduledTimeController;
  late TextEditingController _serviceTypeController;
  late TextEditingController _descriptionController;
  late TextEditingController _totalValueController;

  var _isInit = true;

  @override
  void initState() {
    super.initState();

    if (widget.service != null) {
      if (widget.service!.scheduledDate.isNotEmpty) {
        _selectedDate = DateTime.tryParse(widget.service!.scheduledDate);
      }
      if (widget.service!.scheduledTime.isNotEmpty) {
        final parts = widget.service!.scheduledTime.split(':');
        if (parts.length >= 2) {
          _selectedTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      }
    }

    _selectedVehicleId = widget.service?.vehicleId;
    _selectedStatus = widget.service?.status ?? 'Agendado';

    _scheduledDateController = TextEditingController(
      text: _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : '',
    );
    _employeeIdController = TextEditingController(
      text: widget.service?.employeeId ?? '',
    );
    _serviceTypeController = TextEditingController(
      text: widget.service?.serviceType ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.service?.description ?? '',
    );
    _totalValueController = TextEditingController(
      text: widget.service?.totalValue.toString() ?? '',
    );
    _scheduledTimeController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<VehicleViewModel>(context, listen: false).fetchVehicles();
      Provider.of<ServiceViewModel>(context, listen: false).fetchServices();

      _scheduledTimeController.text = _selectedTime != null
          ? _selectedTime!.format(context)
          : '';
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _scheduledDateController.dispose();
    _scheduledTimeController.dispose();
    _serviceTypeController.dispose();
    _descriptionController.dispose();
    _totalValueController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _scheduledDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _scheduledTimeController.text = picked.format(context);
      });
    }
  }

  void _saveService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final serviceViewModel = Provider.of<ServiceViewModel>(
      context,
      listen: false,
    );

    final newService = Service(
      id: widget.service?.id ?? '0',
      vehicleId: _selectedVehicleId!,
      employeeId: _employeeIdController.text,
      scheduledDate: _selectedDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
          : '',
      scheduledTime: _selectedTime != null
          ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00'
          : '',
      serviceType: _serviceTypeController.text,
      status: _selectedStatus!,
      description: _descriptionController.text,
      totalValue: double.tryParse(_totalValueController.text) ?? 0.0,
    );

    bool success = false;

    if (widget.service == null) {
      success = await serviceViewModel.addService(newService);
    } else {
      success = await serviceViewModel.updateService(newService.id, newService);
    }

    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              serviceViewModel.errorMessage ?? "Ocorreu um erro desconhecido.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleViewModel = Provider.of<VehicleViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service == null ? 'Adicionar Serviço' : 'Editar Serviço',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (vehicleViewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (vehicleViewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Erro ao carregar veículos: ${vehicleViewModel.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Veículo',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedVehicleId,
                  hint: const Text('Selecione um veículo'),
                  items: vehicleViewModel.vehicles.map((Vehicle vehicle) {
                    return DropdownMenuItem<String>(
                      value: vehicle.id,
                      child: Text('${vehicle.model} - ${vehicle.licensePlate}'),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedVehicleId = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Por favor, selecione um veículo' : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduledDateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Agendamento',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, selecione a data'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduledTimeController,
                decoration: const InputDecoration(
                  labelText: 'Hora de Agendamento',
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor, selecione a hora'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _serviceTypeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Serviço',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Insira o tipo de serviço'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                value: _selectedStatus,
                items: _statusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Por favor, selecione um status' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Insira a descrição'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _totalValueController,
                decoration: const InputDecoration(
                  labelText: 'Valor Total',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor total';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: _saveService,
                child: Text(
                  widget.service == null
                      ? 'Adicionar Serviço'
                      : 'Salvar Alterações',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
