class AppUser {
  final String id;
  final String email;
  final String nomeCompleto;
  final String? accessToken;

  AppUser({
    required this.id,
    required this.email,
    required this.nomeCompleto,
    this.accessToken,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      email: json['email'],
      nomeCompleto: json['nome_completo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nome_completo': nomeCompleto,
      'accessToken': accessToken,
    };
  }

   factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      nomeCompleto: map['nome_completo'] ?? '',
      accessToken: map['accessToken'],
    );
  }
}
