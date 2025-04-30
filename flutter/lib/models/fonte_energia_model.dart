class FonteEnergia {
  final int? id;
  final String tipo;
  final String descricao;
  final double custoInicial;
  final String beneficios;

  FonteEnergia({
    this.id,
    required this.tipo,
    required this.descricao,
    required this.custoInicial,
    required this.beneficios,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Fonte': id,
      'Tipo': tipo,
      'Descricao': descricao,
      'Custo_Inicial': custoInicial,
      'Beneficios': beneficios,
    };
  }

  factory FonteEnergia.fromMap(Map<String, dynamic> map) {
    return FonteEnergia(
      id: map['ID_Fonte'],
      tipo: map['Tipo'],
      descricao: map['Descricao'],
      custoInicial: map['Custo_Inicial'],
      beneficios: map['Beneficios'],
    );
  }
}
