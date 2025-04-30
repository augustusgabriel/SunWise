class Equipamento {
  final int? id;
  final String nome;
  final double potencia;
  final double tempoUsoDiario;
  final int usuarioId;

  Equipamento({
    this.id,
    required this.nome,
    required this.potencia,
    required this.tempoUsoDiario,
    required this.usuarioId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Equipamento': id,
      'Nome': nome,
      'Potencia': potencia,
      'Tempo_uso_diario': tempoUsoDiario,
      'ID_Usuario': usuarioId,
    };
  }

  factory Equipamento.fromMap(Map<String, dynamic> map) {
    return Equipamento(
      id: map['ID_Equipamento'],
      nome: map['Nome'],
      potencia: map['Potencia'],
      tempoUsoDiario: map['Tempo_uso_diario'],
      usuarioId: map['ID_Usuario'],
    );
  }
}
