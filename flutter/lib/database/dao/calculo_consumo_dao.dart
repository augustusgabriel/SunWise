import '../../models/calculo_consumo_model.dart';
import '../../database/app_database.dart';

class CalculoConsumoDao {
  Future<int> inserir(CalculoConsumo calculo) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('CalculoConsumo', calculo.toMap());
  }

  Future<List<CalculoConsumo>> listarPorUsuario(int usuarioId) async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query(
      'CalculoConsumo',
      where: 'ID_Usuario = ?',
      whereArgs: [usuarioId],
    );
    return result.map((e) => CalculoConsumo.fromMap(e)).toList();
  }
}
