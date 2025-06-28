import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oficina_mecanica/models/invoice.dart';
import 'package:oficina_mecanica/models/payment.dart';
import 'package:oficina_mecanica/models/service.dart';
import 'package:oficina_mecanica/viewmodels/invoice_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/payment_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:provider/provider.dart';

class PaymentDetailScreen extends StatefulWidget {
  final Payment? payment;

  const PaymentDetailScreen({super.key, this.payment});

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _paymentMethodOptions = [
    'Cartao de Credito',
    'Cartao de Debito',
    'Dinheiro',
    'Pix',
    'Transferencia'
  ];

  String? _selectedInvoiceId;
  DateTime? _selectedPaymentDate;
  String? _selectedPaymentMethod;

  late TextEditingController _paymentDateController;
  late TextEditingController _paidValueController;

  var _isInit = true;

  @override
  void initState() {
    super.initState();

    _selectedInvoiceId = widget.payment?.invoiceId;
    _selectedPaymentMethod = widget.payment?.paymentMethod;

    if (widget.payment != null && widget.payment!.paymentDate.isNotEmpty) {
      _selectedPaymentDate = DateTime.tryParse(widget.payment!.paymentDate);
    }

    _paymentDateController = TextEditingController(
      text: _selectedPaymentDate != null
          ? DateFormat('dd/MM/yyyy').format(_selectedPaymentDate!)
          : '',
    );
    _paidValueController = TextEditingController(
      text: widget.payment?.paidValue.toString() ?? '',
    );
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<InvoiceViewModel>(context, listen: false).fetchInvoices();
      Provider.of<ServiceViewModel>(context, listen: false).fetchServices();
      Provider.of<PaymentViewModel>(context, listen: false).fetchPayments();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _paymentDateController.dispose();
    _paidValueController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPaymentDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedPaymentDate) {
      setState(() {
        _selectedPaymentDate = picked;
        _paymentDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _savePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final paymentViewModel =
        Provider.of<PaymentViewModel>(context, listen: false);

    final newPayment = Payment(
      id: widget.payment?.id ?? '0',
      invoiceId: _selectedInvoiceId!,
      paymentDate: _selectedPaymentDate != null
          ? DateFormat('yyyy-MM-dd').format(_selectedPaymentDate!)
          : '',
      paidValue: double.parse(_paidValueController.text),
      paymentMethod: _selectedPaymentMethod!,
    );

    bool success = false;
    if (widget.payment == null) {
      success = await paymentViewModel.addPayment(newPayment);
    } else {
      success = await paymentViewModel.updatePayment(newPayment.id, newPayment);
    }

    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                paymentViewModel.errorMessage ?? "Ocorreu um erro desconhecido."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceViewModel = Provider.of<InvoiceViewModel>(context);
    final serviceViewModel = Provider.of<ServiceViewModel>(context);
    final paymentViewModel = Provider.of<PaymentViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.payment == null ? 'Adicionar Pagamento' : 'Editar Pagamento',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (invoiceViewModel.isLoading || serviceViewModel.isLoading || paymentViewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                Builder(
                  builder: (context) {
                    final paidInvoiceIds = paymentViewModel.payments
                        .map((p) => p.invoiceId)
                        .toSet();

                    final availableInvoices = invoiceViewModel.invoices.where((invoice) {
                      final hasPayment = paidInvoiceIds.contains(invoice.id);
                      final isCurrentInvoiceForEdit = invoice.id == widget.payment?.invoiceId;
                      return !hasPayment || isCurrentInvoiceForEdit;
                    }).toList();
                    
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Fatura',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedInvoiceId,
                      hint: const Text('Selecione uma fatura'),
                      items: availableInvoices.map((Invoice invoice) {
                        final service = serviceViewModel.services.firstWhere(
                          (s) => s.id == invoice.serviceId,
                          orElse: () => Service(id: '', serviceType: 'Serviço', vehicleId: '', scheduledDate: '', scheduledTime: '', status: '', description: '', totalValue: 0),
                        );
                        return DropdownMenuItem<String>(
                          value: invoice.id,
                          child: Text(
                              '${service.serviceType} - R\$ ${invoice.totalInvoiceValue.toStringAsFixed(2)}'),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedInvoiceId = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Por favor, selecione uma fatura' : null,
                    );
                  }
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _paymentDateController,
                decoration: const InputDecoration(
                  labelText: 'Data do Pagamento',
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
                controller: _paidValueController,
                decoration: const InputDecoration(
                  labelText: 'Valor Pago',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insira o valor pago';
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
                  labelText: 'Método de Pagamento',
                  border: OutlineInputBorder(),
                ),
                value: _selectedPaymentMethod,
                hint: const Text('Selecione o método'),
                items: _paymentMethodOptions.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Por favor, selecione um método' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: _savePayment,
                child: Text(
                    widget.payment == null ? 'Adicionar' : 'Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}