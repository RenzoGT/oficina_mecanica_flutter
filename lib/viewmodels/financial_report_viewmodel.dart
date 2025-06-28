import 'package:flutter/material.dart';
import 'package:oficina_mecanica/models/invoice.dart';
import 'package:oficina_mecanica/services/invoice_service.dart';
import 'package:oficina_mecanica/services/payment_service.dart';

class FinancialReportViewModel extends ChangeNotifier {
  final InvoiceService _invoiceService = InvoiceService();
  final PaymentService _paymentService = PaymentService();

  bool _isLoading = false;
  String? _errorMessage;

  double _totalBilled = 0;
  double _totalReceived = 0;
  List<Invoice> _openInvoices = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get totalBilled => _totalBilled;
  double get totalReceived => _totalReceived;
  double get balanceReceivable => _totalBilled - _totalReceived;
  List<Invoice> get openInvoices => _openInvoices;

  Future<void> generateReport() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final allInvoices = await _invoiceService.getInvoices();
      final allPayments = await _paymentService.getPayments();

      _totalBilled = allInvoices.fold(
        0,
        (sum, item) => sum + item.totalInvoiceValue,
      );
      _totalReceived = allPayments.fold(0, (sum, item) => sum + item.paidValue);

      _openInvoices = allInvoices
          .where((invoice) => invoice.paymentStatus != 'Pago')
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
