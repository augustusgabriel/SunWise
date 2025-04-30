class Localizacao {
  final int? id;
  final String cidade;
  final String estado;
  final String cep;

  Localizacao({
    this.id,
    required this.cidade,
    required this.estado,
    required this.cep,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Localizacao': id,
      'Cidade': cidade,
      'Estado': estado,
      'CEP': cep,
    };
  }

  factory Localizacao.fromMap(Map<String, dynamic> map) {
    return Localizacao(
      id: map['ID_Localizacao'],
      cidade: map['Cidade'],
      estado: map['Estado'],
      cep: map['CEP'],
    );
  }
}
