import '../../models/fornecedor_solucoes_model.dart';
import '../../database/app_database.dart';

class FornecedorSolucoesDao {
  Future<int> inserir(FornecedorSolucoes solucao) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('FornecedorSolucoes', solucao.toMap());
  }

  Future<List<FornecedorSolucoes>> listarPorFornecedor(int fornecedorId) async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query(
      'FornecedorSolucoes',
      where: 'ID_Fornecedor = ?',
      whereArgs: [fornecedorId],
    );
    return result.map((e) => FornecedorSolucoes.fromMap(e)).toList();
  }

  Future<List<FornecedorSolucoes>> listarPorLocalizacao(String localizacao) async {
  final db = await DatabaseHelper.initDB();

  final List<Map<String, dynamic>> maps = await db.query(
    'Fornecedor_Solucoes',
    where: 'Localizacao_Fornecedor LIKE ?',
    whereArgs: ['%$localizacao%'],
  );

  return maps.map((map) => FornecedorSolucoes.fromMap(map)).toList();
}
}
