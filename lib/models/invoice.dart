class Invoice {
  final String id;
  final String serviceId;
  final String issueDate;
  final double totalInvoiceValue;
  final String paymentStatus;

  Invoice({
    required this.id,
    required this.serviceId,
    required this.issueDate,
    required this.totalInvoiceValue,
    required this.paymentStatus,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['fatura_id'],
      serviceId: json['servico_id'],
      issueDate: json['data_emissao'],
      totalInvoiceValue: json['valor_total_fatura'].toDouble(),
      paymentStatus: json['status_pagamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ServicoID': serviceId,
      'DataEmissao': issueDate,
      'ValorTotalFatura': totalInvoiceValue,
      'StatusPagamento': paymentStatus,
    };
  }
}
