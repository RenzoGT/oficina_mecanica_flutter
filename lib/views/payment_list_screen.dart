import 'package:flutter/material.dart';
import 'package:oficina_mecanica/models/invoice.dart';
import 'package:oficina_mecanica/models/payment.dart';
import 'package:oficina_mecanica/models/service.dart';
import 'package:oficina_mecanica/viewmodels/invoice_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/payment_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:oficina_mecanica/views/financial_report_screen.dart';
import 'package:oficina_mecanica/views/payment_detail_screen.dart';
import 'package:provider/provider.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllData();
    });
  }

  Future<void> _fetchAllData() async {
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final invoiceVM = Provider.of<InvoiceViewModel>(context, listen: false);
    final serviceVM = Provider.of<ServiceViewModel>(context, listen: false);

    await Future.wait([
      paymentVM.fetchPayments(),
      invoiceVM.fetchInvoices(),
      serviceVM.fetchServices(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final paymentViewModel = Provider.of<PaymentViewModel>(context);
    final invoiceViewModel = Provider.of<InvoiceViewModel>(context);
    final serviceViewModel = Provider.of<ServiceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Gerar Relatório Financeiro',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinancialReportScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (paymentViewModel.isLoading ||
              invoiceViewModel.isLoading ||
              serviceViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (paymentViewModel.errorMessage != null) {
            return Center(
              child: Text('Error: ${paymentViewModel.errorMessage}'),
            );
          }

          if (invoiceViewModel.errorMessage != null) {
            return Center(
              child: Text('Error: ${invoiceViewModel.errorMessage}'),
            );
          }

          if (paymentViewModel.payments.isEmpty) {
            return const Center(child: Text('Nenhum pagamento cadastrado.'));
          }

          return RefreshIndicator(
            onRefresh: _fetchAllData,
            child: ListView.builder(
              itemCount: paymentViewModel.payments.length,
              itemBuilder: (context, index) {
                final payment = paymentViewModel.payments[index];
                final invoice = invoiceViewModel.invoices.firstWhere(
                  (inv) => inv.id == payment.invoiceId,
                  orElse: () => Invoice(
                    id: '',
                    serviceId: '',
                    issueDate: '',
                    totalInvoiceValue: 0,
                    paymentStatus: 'N/A',
                  ),
                );
                final service = serviceViewModel.services.firstWhere(
                  (srv) => srv.id == invoice.serviceId,
                  orElse: () => Service(
                    id: '',
                    vehicleId: '',
                    scheduledDate: '',
                    scheduledTime: '',
                    serviceType: 'Fatura',
                    status: '',
                    description: '',
                    totalValue: 0,
                  ),
                );

                return ListTile(
                  leading: const Icon(Icons.payment, color: Colors.grey),
                  title: Text(
                    'Pagamento: ${service.serviceType} - R\$${payment.paidValue.toStringAsFixed(2)}',
                  ),
                  subtitle: Text(
                    'Método: ${payment.paymentMethod} - Data: ${payment.paymentDate}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentDetailScreen(payment: payment),
                      ),
                    ).then((_) => _fetchAllData());
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      paymentViewModel.deletePayment(payment.id);
                    },
                  ),
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
              builder: (context) => const PaymentDetailScreen(),
            ),
          ).then((_) => _fetchAllData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
