import 'package:flutter/material.dart';
import 'package:oficina_mecanica/models/part.dart';

class StockReportScreen extends StatelessWidget {
  final List<Part> parts;

  const StockReportScreen({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatório de Estoque')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: parts.length,
        itemBuilder: (context, index) {
          final part = parts[index];
          final bool isLowStock = part.quantity <= part.minLevel;
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: isLowStock ? Colors.orange.shade800 : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (part.description.isNotEmpty) ...[
                    Text(
                      part.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantidade: ${part.quantity}'),
                      Text('Nível Mínimo: ${part.minLevel}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Preço de Custo: R\$ ${part.costPrice.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Preço de Venda: R\$ ${part.salePrice.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
