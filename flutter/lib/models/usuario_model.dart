class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String tipoConta;
  final int? localizacaoId;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.tipoConta,
    this.localizacaoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Usuario': id,
      'Nome': nome,
      'Email': email,
      'Senha': senha,
      'Tipo_Conta': tipoConta,
      'Localizacao_Usuario': localizacaoId,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['ID_Usuario'],
      nome: map['Nome'],
      email: map['Email'],
      senha: map['Senha'],
      tipoConta: map['Tipo_Conta'],
      localizacaoId: map['Localizacao_Usuario'],
    );
  }
}
