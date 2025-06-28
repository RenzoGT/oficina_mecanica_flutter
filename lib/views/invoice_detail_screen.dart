import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oficina_mecanica/models/invoice.dart';
import 'package:oficina_mecanica/models/service.dart';
import 'package:oficina_mecanica/viewmodels/invoice_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:provider/provider.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final Invoice? invoice;

  const InvoiceDetailScreen({super.key, this.invoice});

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _paymentStatusOptions = [
    'Aberto',
    'Parcialmente Pago',
    'Pago',
  ];

  String? _selectedServiceId;
  DateTime? _selectedDate;
  String? _selectedPaymentStatus;

  late TextEditingController _issueDateController;
  late TextEditingController _totalInvoiceValueController;

  var _isInit = true;

  @override
  void initState() {
    super.initState();

    _selectedServiceId = widget.invoice?.serviceId;
    _selectedPaymentStatus = widget.invoice?.paymentStatus;

    if (widget.invoice != null && widget.invoice!.issueDate.isNotEmpty) {
      _selectedDate = DateTime.tryParse(widget.invoice!.issueDate);
    }

    _issueDateController = TextEditingController(
      text: _selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
          : '',
    );
    _totalInvoiceValueController = TextEditingController(
      text: widget.invoice?.totalInvoiceValue.toString() ?? '',
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<ServiceViewModel>(context, listen: false).fetchServices();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _issueDateController.dispose();
    _totalInvoiceValueController.dispose();
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
        _issueDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _saveInvoice() {
    if (_formKey.currentState!.validate()) {
      final invoiceViewModel = Provider.of<InvoiceViewModel>(
        context,
        listen: false,
      );

      final newInvoice = Invoice(
        id: widget.invoice?.id ?? '0',
        serviceId: _selectedServiceId!,
        issueDate: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : '',
        totalInvoiceValue: double.parse(_totalInvoiceValueController.text),
        paymentStatus: _selectedPaymentStatus!,
      );

      if (widget.invoice == null) {
        invoiceViewModel.addInvoice(newInvoice);
      } else {
        invoiceViewModel.updateInvoice(newInvoice.id, newInvoice);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final serviceViewModel = Provider.of<ServiceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.invoice == null ? 'Adicionar Fatura' : 'Editar Fatura',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (serviceViewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (serviceViewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Erro ao carregar serviços: ${serviceViewModel.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Serviço',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedServiceId,
                  hint: const Text('Selecione um serviço'),
                  items: serviceViewModel.services.map((Service service) {
                    return DropdownMenuItem<String>(
                      value: service.id,
                      child: Text(service.serviceType),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedServiceId = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Por favor, selecione um serviço' : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _issueDateController,
                decoration: const InputDecoration(
                  labelText: 'Data de Emissão',
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
                controller: _totalInvoiceValueController,
                decoration: const InputDecoration(
                  labelText: 'Valor Total da Fatura',
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
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Status do Pagamento',
                  border: OutlineInputBorder(),
                ),
                value: _selectedPaymentStatus,
                hint: const Text('Selecione o status'),
                items: _paymentStatusOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentStatus = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Por favor, selecione um status' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: _saveInvoice,
                child: Text(
                  widget.invoice == null ? 'Adicionar' : 'Salvar Alterações',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
