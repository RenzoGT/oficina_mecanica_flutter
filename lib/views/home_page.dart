// lib/views/home_page.dart

import 'package:flutter/material.dart';
import 'package:oficina_mecanica/viewmodels/auth_viewmodel.dart';
import 'package:oficina_mecanica/views/client_list_screen.dart';
import 'package:oficina_mecanica/views/vehicle_list_screen.dart';
import 'package:oficina_mecanica/views/part_list_screen.dart';
import 'package:oficina_mecanica/views/invoice_list_screen.dart';
import 'package:oficina_mecanica/views/payment_list_screen.dart';
import 'package:oficina_mecanica/views/service_list_screen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    ClientListScreen(),
    VehicleListScreen(),
    ServiceListScreen(),
    PartListScreen(),
    InvoiceListScreen(),
    PaymentListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person_outline, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                user?.nomeCompleto ?? 'Usuário',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              authViewModel.logout();
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Veículos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Serviços'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Peças'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Faturas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pagamentos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
