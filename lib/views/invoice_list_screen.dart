import 'package:flutter/material.dart';
import 'package:oficina_mecanica/models/service.dart';
import 'package:oficina_mecanica/viewmodels/invoice_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:oficina_mecanica/views/invoice_detail_screen.dart';
import 'package:oficina_mecanica/views/invoice_view_screen.dart';
import 'package:provider/provider.dart';

class InvoiceListScreen extends StatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  State<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllData();
    });
  }

  Future<void> _fetchAllData() async {
    final invoiceVM = Provider.of<InvoiceViewModel>(context, listen: false);
    final serviceVM = Provider.of<ServiceViewModel>(context, listen: false);

    await Future.wait([invoiceVM.fetchInvoices(), serviceVM.fetchServices()]);
  }

  @override
  Widget build(BuildContext context) {
    final invoiceVM = Provider.of<InvoiceViewModel>(context);
    final serviceVM = Provider.of<ServiceViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Faturas')),
      body: Builder(
        builder: (context) {
          if (invoiceVM.isLoading || serviceVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (invoiceVM.errorMessage != null) {
            return Center(child: Text('Error: ${invoiceVM.errorMessage}'));
          }

          if (invoiceVM.invoices.isEmpty) {
            return const Center(child: Text('Nenhuma fatura cadastrada.'));
          }

          return RefreshIndicator(
            onRefresh: _fetchAllData,
            child: ListView.builder(
              itemCount: invoiceVM.invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoiceVM.invoices[index];

                final service = serviceVM.services.firstWhere(
                  (s) => s.id == invoice.serviceId,
                  orElse: () => Service(
                    id: '',
                    serviceType: 'Serviço não encontrado',
                    vehicleId: '',
                    scheduledDate: '',
                    scheduledTime: '',
                    status: '',
                    description: '',
                    totalValue: 0,
                  ),
                );

                return ListTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.grey),
                  title: Text(
                    '${service.serviceType} - R\$${invoice.totalInvoiceValue.toStringAsFixed(2)}',
                  ),
                  subtitle: Text(
                    'Status: ${invoice.paymentStatus} - Data: ${invoice.issueDate}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        tooltip: 'Visualizar Fatura',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => InvoiceViewScreen(
                                invoice: invoice,
                                service: service,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        tooltip: 'Excluir Fatura',
                        onPressed: () {
                          invoiceVM.deleteInvoice(invoice.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            InvoiceDetailScreen(invoice: invoice),
                      ),
                    ).then((_) => _fetchAllData());
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InvoiceDetailScreen(),
            ),
          ).then((_) => _fetchAllData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
