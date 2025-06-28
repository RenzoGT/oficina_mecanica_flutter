import 'package:flutter/material.dart';
import 'package:oficina_mecanica/models/invoice.dart';
import 'package:oficina_mecanica/models/service.dart';

class InvoiceViewScreen extends StatelessWidget {
  final Invoice invoice;
  final Service service;

  const InvoiceViewScreen({
    super.key,
    required this.invoice,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes da Fatura')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Fatura Detalhada',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 30, thickness: 1),

                Text(
                  'Serviço Prestado',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  service.serviceType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  service.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const Divider(height: 30, thickness: 1),

                Text(
                  'Resumo Financeiro',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data de Emissão'),
                  trailing: Text(invoice.issueDate),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Status do Pagamento'),
                  trailing: Chip(label: Text(invoice.paymentStatus)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'VALOR TOTAL',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  trailing: Text(
                    'R\$ ${invoice.totalInvoiceValue.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
