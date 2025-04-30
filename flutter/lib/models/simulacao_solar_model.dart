class SimulacaoSolar {
  final int? id;
  final double consumoMensal;
  final String localizacao;
  final double roi;
  final double economiaAnual;
  final int usuarioId;
  final String dataSimulacao;

  SimulacaoSolar({
    this.id,
    required this.consumoMensal,
    required this.localizacao,
    required this.roi,
    required this.economiaAnual,
    required this.usuarioId,
    required this.dataSimulacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Simulacao': id,
      'Consumo_Mensal': consumoMensal,
      'Localizacao': localizacao,
      'ROI': roi,
      'Economia_Anual': economiaAnual,
      'ID_Usuario': usuarioId,
      'Data_Simulacao': dataSimulacao,
    };
  }

  factory SimulacaoSolar.fromMap(Map<String, dynamic> map) {
    return SimulacaoSolar(
      id: map['ID_Simulacao'],
      consumoMensal: map['Consumo_Mensal'],
      localizacao: map['Localizacao'],
      roi: map['ROI'],
      economiaAnual: map['Economia_Anual'],
      usuarioId: map['ID_Usuario'],
      dataSimulacao: map['Data_Simulacao'],
    );
  }
}
