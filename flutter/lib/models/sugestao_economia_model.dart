class SugestaoEconomia {
  final int? id;
  final String texto;
  final String tipo;
  final int calculoId;

  SugestaoEconomia({
    this.id,
    required this.texto,
    required this.tipo,
    required this.calculoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Sugestao': id,
      'Texto_Sugestao': texto,
      'Tipo_Sugestao': tipo,
      'ID_Calculo': calculoId,
    };
  }

  factory SugestaoEconomia.fromMap(Map<String, dynamic> map) {
    return SugestaoEconomia(
      id: map['ID_Sugestao'],
      texto: map['Texto_Sugestao'],
      tipo: map['Tipo_Sugestao'],
      calculoId: map['ID_Calculo'],
    );
  }
}
