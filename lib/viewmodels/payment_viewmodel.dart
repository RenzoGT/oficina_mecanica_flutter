import 'package:flutter/material.dart';
import '../models/payment.dart';
import '../services/payment_service.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  List<Payment> _payments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Payment> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPayments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _payments = await _paymentService.getPayments();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addPayment(Payment payment) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _paymentService.createPayment(payment);
      await fetchPayments();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<bool> updatePayment(String id, Payment payment) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _paymentService.updatePayment(id, payment);
      await fetchPayments();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> deletePayment(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _paymentService.deletePayment(id);
      await fetchPayments();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaymentsByInvoiceId(String invoiceId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _payments = await _paymentService.getPaymentsByInvoiceId(invoiceId);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
