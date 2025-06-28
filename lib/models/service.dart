class Service {
  final String id;
  final String vehicleId;
  final String? employeeId;
  final String scheduledDate;
  final String scheduledTime;
  final String serviceType;
  final String status;
  final String description;
  final double totalValue;

  Service({
    required this.id,
    required this.vehicleId,
    this.employeeId,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.serviceType,
    required this.status,
    required this.description,
    required this.totalValue,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['servico_id'],
      vehicleId: json['veiculo_id'],
      employeeId: null,
      scheduledDate: json['data_agendamento'],
      scheduledTime: json['hora_agendamento'],
      serviceType: json['tipo_servico'],
      status: json['status'],
      description: json['descricao'],
      totalValue: json['valor_total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'VeiculoID': vehicleId,
      'FuncionarioID': null,
      'DataAgendamento': scheduledDate,
      'HoraAgendamento': scheduledTime,
      'TipoServico': serviceType,
      'Status': status,
      'Descricao': description,
      'ValorTotal': totalValue,
    };
  }
}
