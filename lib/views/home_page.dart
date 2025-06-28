import 'package:flutter/material.dart';
import 'package:oficina_mecanica/views/client_list_screen.dart';
import 'package:oficina_mecanica/views/vehicle_list_screen.dart';
import 'package:oficina_mecanica/views/part_list_screen.dart';
import 'package:oficina_mecanica/views/invoice_list_screen.dart';
import 'package:oficina_mecanica/views/payment_list_screen.dart';
import 'package:oficina_mecanica/views/service_list_screen.dart';

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

  static const List<String> _appBarTitles = <String>[
    'Clientes',
    'Veículos',
    'Serviços',
    'Estoque de Peças',
    'Faturas',
    'Pagamentos',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

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
