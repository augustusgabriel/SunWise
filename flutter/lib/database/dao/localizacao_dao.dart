import '../../models/localizacao_model.dart';
import '../../database/app_database.dart';

class LocalizacaoDao {
  Future<int> inserir(Localizacao loc) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('Localizacao', loc.toMap());
  }

  Future<List<Localizacao>> listarTodos() async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query('Localizacao');
    return result.map((e) => Localizacao.fromMap(e)).toList();
  }
}
