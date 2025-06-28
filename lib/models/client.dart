class Client {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;

  Client({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['cliente_id'],
      name: json['nome'],
      address: json['endereco'],
      phone: json['telefone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Nome': name,
      'Endereco': address,
      'Telefone': phone,
      'Email': email,
    };
  }
}
