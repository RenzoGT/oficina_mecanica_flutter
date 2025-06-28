import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oficina_mecanica/models/invoice.dart';
import 'package:oficina_mecanica/models/service.dart';
import 'package:oficina_mecanica/viewmodels/financial_report_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:provider/provider.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FinancialReportViewModel>(
        context,
        listen: false,
      ).generateReport();
      Provider.of<ServiceViewModel>(context, listen: false).fetchServices();
    });
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required double value,
    required IconData icon,
    required Color color,
  }) {
    final formatCurrency = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              formatCurrency.format(value),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = Provider.of<FinancialReportViewModel>(context);
    final serviceViewModel = Provider.of<ServiceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório Financeiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              reportViewModel.generateReport();
              serviceViewModel.fetchServices();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (reportViewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (reportViewModel.errorMessage != null) {
            return Center(child: Text('Erro: ${reportViewModel.errorMessage}'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMetricCard(
                  context,
                  title: 'Total Faturado',
                  value: reportViewModel.totalBilled,
                  icon: Icons.trending_up,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(height: 16),
                _buildMetricCard(
                  context,
                  title: 'Total Recebido',
                  value: reportViewModel.totalReceived,
                  icon: Icons.check_circle,
                  color: Colors.green.shade700,
                ),
                const SizedBox(height: 16),
                _buildMetricCard(
                  context,
                  title: 'Saldo a Receber',
                  value: reportViewModel.balanceReceivable,
                  icon: Icons.hourglass_empty,
                  color: Colors.orange.shade800,
                ),
                const Divider(height: 40, thickness: 1),
                Text(
                  'Contas a Receber (Faturas em Aberto)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                if (reportViewModel.openInvoices.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Nenhuma fatura em aberto.'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reportViewModel.openInvoices.length,
                    itemBuilder: (context, index) {
                      final invoice = reportViewModel.openInvoices[index];
                      final service = serviceViewModel.services.firstWhere(
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

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(service.serviceType),
                          subtitle: Text(
                            'Status: ${invoice.paymentStatus} | Emissão: ${invoice.issueDate}',
                          ),
                          trailing: Text(
                            'R\$ ${invoice.totalInvoiceValue.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
