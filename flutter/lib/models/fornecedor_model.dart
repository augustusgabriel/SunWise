class Fornecedor {
  final int? id;
  final String nome;
  final String tipoServico;
  final String endereco;
  final String telefone;
  final String email;
  final double avaliacao;

  Fornecedor({
    this.id,
    required this.nome,
    required this.tipoServico,
    required this.endereco,
    required this.telefone,
    required this.email,
    required this.avaliacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Fornecedor': id,
      'Nome_Fornecedor': nome,
      'Tipo_Servico': tipoServico,
      'Endereco': endereco,
      'Telefone': telefone,
      'Email': email,
      'Avaliacao': avaliacao,
    };
  }

  factory Fornecedor.fromMap(Map<String, dynamic> map) {
    return Fornecedor(
      id: map['ID_Fornecedor'],
      nome: map['Nome_Fornecedor'],
      tipoServico: map['Tipo_Servico'],
      endereco: map['Endereco'],
      telefone: map['Telefone'],
      email: map['Email'],
      avaliacao: map['Avaliacao'],
    );
  }
}
