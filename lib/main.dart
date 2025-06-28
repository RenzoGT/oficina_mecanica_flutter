import 'package:flutter/material.dart';
import 'package:oficina_mecanica/viewmodels/financial_report_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:oficina_mecanica/views/home_page.dart';
import 'package:oficina_mecanica/viewmodels/client_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/vehicle_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/part_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/service_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/invoice_viewmodel.dart';
import 'package:oficina_mecanica/viewmodels/payment_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClientViewModel()),
        ChangeNotifierProvider(create: (_) => VehicleViewModel()),
        ChangeNotifierProvider(create: (_) => PartViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceViewModel()),
        ChangeNotifierProvider(create: (_) => InvoiceViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => FinancialReportViewModel()),
      ],
      child: MaterialApp(
        title: 'Oficina Mecânica',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
