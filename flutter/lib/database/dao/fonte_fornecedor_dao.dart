import '../../models/fonte_fornecedor_model.dart';
import '../../database/app_database.dart';

class FonteFornecedorDao {
  Future<int> vincular(FonteFornecedor rel) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('FonteFornecedor', rel.toMap());
  }

  Future<List<FonteFornecedor>> listarPorFonte(int fonteId) async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query(
      'FonteFornecedor',
      where: 'ID_Fonte = ?',
      whereArgs: [fonteId],
    );
    return result.map((e) => FonteFornecedor.fromMap(e)).toList();
  }
}
