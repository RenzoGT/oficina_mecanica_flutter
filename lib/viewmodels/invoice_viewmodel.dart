import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/invoice_service.dart';

class InvoiceViewModel extends ChangeNotifier {
  final InvoiceService _invoiceService = InvoiceService();
  List<Invoice> _invoices = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchInvoices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _invoices = await _invoiceService.getInvoices();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addInvoice(Invoice invoice) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _invoiceService.createInvoice(invoice);
      await fetchInvoices();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateInvoice(String id, Invoice invoice) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _invoiceService.updateInvoice(id, invoice);
      await fetchInvoices(); 
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteInvoice(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _invoiceService.deleteInvoice(id);
      await fetchInvoices(); 
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOpenInvoices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _invoices = await _invoiceService.getOpenInvoices();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
