import '../../models/fornecedor_model.dart';
import '../../database/app_database.dart';

class FornecedorDao {
  Future<int> inserir(Fornecedor fornecedor) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('Fornecedores', fornecedor.toMap());
  }

  Future<List<Fornecedor>> listarTodos() async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query('Fornecedores');
    return result.map((e) => Fornecedor.fromMap(e)).toList();
  }
}
