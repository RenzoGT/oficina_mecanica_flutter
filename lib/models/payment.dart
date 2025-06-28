import 'package:flutter/foundation.dart';

class Payment {
  final String id;
  final String invoiceId;
  final String paymentDate;
  final double paidValue;
  final String paymentMethod;

  Payment({
    required this.id,
    required this.invoiceId,
    required this.paymentDate,
    required this.paidValue,
    required this.paymentMethod,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['pagamento_id'],
      invoiceId: json['fatura_id'],
      paymentDate: json['data_pagamento'],
      paidValue: json['valor_pago'].toDouble(),
      paymentMethod: json['metodo_pagamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'FaturaID': invoiceId,
      'DataPagamento': paymentDate,
      'ValorPago': paidValue,
      'MetodoPagamento': paymentMethod,
    };
  }
}
