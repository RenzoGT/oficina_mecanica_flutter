import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oficina_mecanica/viewmodels/part_viewmodel.dart';
import 'package:oficina_mecanica/models/part.dart';

class PartDetailScreen extends StatefulWidget {
  final Part? part;

  const PartDetailScreen({super.key, this.part});

  @override
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _costPriceController;
  late TextEditingController _salePriceController;
  late TextEditingController _minLevelController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.part?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.part?.description ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.part?.quantity.toString() ?? '',
    );
    _costPriceController = TextEditingController(
      text: widget.part?.costPrice.toString() ?? '',
    );
    _salePriceController = TextEditingController(
      text: widget.part?.salePrice.toString() ?? '',
    );
    _minLevelController = TextEditingController(
      text: widget.part?.minLevel.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _costPriceController.dispose();
    _salePriceController.dispose();
    _minLevelController.dispose();
    super.dispose();
  }

  void _savePart() {
    if (_formKey.currentState!.validate()) {
      final partViewModel = Provider.of<PartViewModel>(context, listen: false);
      final newPart = Part(
        id: (widget.part?.id ?? 0)
            .toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        quantity: int.parse(_quantityController.text),
        costPrice: double.parse(_costPriceController.text),
        salePrice: double.parse(_salePriceController.text),
        minLevel: int.parse(_minLevelController.text),
      );

      if (widget.part == null) {
        partViewModel.addPart(newPart);
      } else {
        partViewModel.updatePart(newPart.id, newPart);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.part == null ? 'Adicionar Peça' : 'Editar Peça'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da Peça'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da peça';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _costPriceController,
                decoration: const InputDecoration(labelText: 'Preço de Custo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço de custo';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salePriceController,
                decoration: const InputDecoration(labelText: 'Preço de Venda'),
                keyboardType: TextInputType.number, 
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço de venda';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _minLevelController,
                decoration: const InputDecoration(labelText: 'Nível Mínimo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nível mínimo';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePart,
                child: Text(widget.part == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
