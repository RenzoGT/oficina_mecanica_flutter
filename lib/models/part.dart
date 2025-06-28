class Part {
  final String id;
  final String name;
  final String description;
  final int quantity;
  final double costPrice;
  final double salePrice;
  final int minLevel;

  Part({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.costPrice,
    required this.salePrice,
    required this.minLevel,
  });

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['peca_id'],
      name: json['nome_peca'],
      description: json['descricao'],
      quantity: json['quantidade'],
      costPrice: json['preco_custo'].toDouble(),
      salePrice: json['preco_venda'].toDouble(),
      minLevel: json['nivel_minimo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'NomePeca': name,
      'Descricao': description,
      'Quantidade': quantity,
      'PrecoCusto': costPrice,
      'PrecoVenda': salePrice,
      'NivelMinimo': minLevel,
    };
  }
}
