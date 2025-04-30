class FornecedorSolucoes {
  final int? id;
  final String tipoSolucao;
  final double custoInstalacao;
  final String localizacaoFornecedor;
  final int fornecedorId;

  FornecedorSolucoes({
    this.id,
    required this.tipoSolucao,
    required this.custoInstalacao,
    required this.localizacaoFornecedor,
    required this.fornecedorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Fornecedor_Solucao': id,
      'Tipo_Solucao': tipoSolucao,
      'Custo_Instalacao': custoInstalacao,
      'Localizacao_Fornecedor': localizacaoFornecedor,
      'ID_Fornecedor': fornecedorId,
    };
  }

  factory FornecedorSolucoes.fromMap(Map<String, dynamic> map) {
    return FornecedorSolucoes(
      id: map['ID_Fornecedor_Solucao'],
      tipoSolucao: map['Tipo_Solucao'],
      custoInstalacao: map['Custo_Instalacao'],
      localizacaoFornecedor: map['Localizacao_Fornecedor'],
      fornecedorId: map['ID_Fornecedor'],
    );
  }
}
