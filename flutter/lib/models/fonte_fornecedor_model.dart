class FonteFornecedor {
  final int fonteId;
  final int fornecedorSolucaoId;

  FonteFornecedor({
    required this.fonteId,
    required this.fornecedorSolucaoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'ID_Fonte': fonteId,
      'ID_Fornecedor_Solucao': fornecedorSolucaoId,
    };
  }

  factory FonteFornecedor.fromMap(Map<String, dynamic> map) {
    return FonteFornecedor(
      fonteId: map['ID_Fonte'],
      fornecedorSolucaoId: map['ID_Fornecedor_Solucao'],
    );
  }
}
