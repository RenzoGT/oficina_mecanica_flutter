import 'package:flutter/foundation.dart';

class Vehicle {
  final String id;
  final String clientId;
  final String model;
  final int year;
  final String licensePlate;
  final String clientName;
  final String chassis;
  final String? serviceHistory;

  Vehicle({
    required this.id,
    required this.clientId,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.clientName,
    required this.chassis,
    required this.serviceHistory,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['veiculo_id'],
      clientId: json['cliente_id'],
      clientName: json['clientes']['nome'],
      model: json['modelo'],
      year: json['ano'],
      licensePlate: json['placa'],
      chassis: json['chassi'],
      serviceHistory: json['historico_servicos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ClienteID': clientId,
      'Modelo': model,
      'Ano': year,
      'Placa': licensePlate,
      'Chassi': chassis,
      'historico_servicos': serviceHistory,
    };
  }
}
