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
}
