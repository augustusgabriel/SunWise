class CalculoConsumo {
  final int? id;
  final double consumoTotal;
  final double custoTotal;
  final int usuarioId;
  final String dataCalculo;

  CalculoConsumo({
    this.id,
    required this.consumoTotal,
    required this.custoTotal,
    required this.usuarioId,
    required this.dataCalculo,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Calculo': id,
      'Consumo_Total': consumoTotal,
      'Custo_Total': custoTotal,
      'ID_Usuario': usuarioId,
      'Data_Calculo': dataCalculo,
    };
  }

  factory CalculoConsumo.fromMap(Map<String, dynamic> map) {
    return CalculoConsumo(
      id: map['ID_Calculo'],
      consumoTotal: map['Consumo_Total'],
      custoTotal: map['Custo_Total'],
      usuarioId: map['ID_Usuario'],
      dataCalculo: map['Data_Calculo'],
    );
  }
}
