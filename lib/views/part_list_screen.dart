import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oficina_mecanica/viewmodels/part_viewmodel.dart';
import 'package:oficina_mecanica/views/part_detail_screen.dart';
import 'package:oficina_mecanica/models/part.dart';
import 'package:oficina_mecanica/views/stock_report_screen.dart';

class PartListScreen extends StatefulWidget {
  const PartListScreen({super.key});

  @override
  State<PartListScreen> createState() => _PartListScreenState();
}

class _PartListScreenState extends State<PartListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PartViewModel>(context, listen: false).fetchParts().then((_) {
        if (!mounted) return;

        final viewModel = Provider.of<PartViewModel>(context, listen: false);
        if (viewModel.lowStockParts.isNotEmpty) {
          final partNames = viewModel.lowStockParts
              .map((p) => p.name)
              .join(', ');
          final message = "As peças $partNames precisam ser reabastecidas.";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.orange.shade800,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peças em Estoque'),
        actions: [
          Consumer<PartViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.assessment),
                tooltip: 'Gerar Relatório de Estoque',
                onPressed: viewModel.parts.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StockReportScreen(parts: viewModel.parts),
                          ),
                        );
                      },
              );
            },
          ),
        ],
      ),
      body: Consumer<PartViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.parts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage != null) {
            return Center(child: Text('Error: ${viewModel.errorMessage}'));
          } else if (viewModel.parts.isEmpty) {
            return const Center(child: Text('Nenhuma peça cadastrada.'));
          } else {
            return RefreshIndicator(
              onRefresh: () => viewModel.fetchParts(),
              child: ListView.builder(
                itemCount: viewModel.parts.length,
                itemBuilder: (context, index) {
                  final part = viewModel.parts[index];
                  final bool isLowStock = part.quantity <= part.minLevel;
                  return ListTile(
                    leading: isLowStock
                        ? Tooltip(
                            message: "Necessário reabastecer peça",
                            child: Icon(
                              Icons.warning,
                              color: Colors.orange.shade800,
                            ),
                          )
                        : const Icon(
                            Icons.build_circle_outlined,
                            color: Colors.grey,
                          ),
                    title: Text(part.name),
                    subtitle: Text(
                      'Quantidade: ${part.quantity} | Preço: R\$${part.salePrice.toStringAsFixed(2)}',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartDetailScreen(part: part),
                        ),
                      ).then((_) => viewModel.fetchParts());
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        viewModel.deletePart(part.id);
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PartDetailScreen()),
          ).then(
            (_) =>
                Provider.of<PartViewModel>(context, listen: false).fetchParts(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
