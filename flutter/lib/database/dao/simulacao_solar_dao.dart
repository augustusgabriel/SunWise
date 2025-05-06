import '../../models/simulacao_solar_model.dart';
import '../../database/app_database.dart';

class SimulacaoSolarDao {
  Future<int> inserir(SimulacaoSolar simulacao) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('SimulacaoSolar', simulacao.toMap());
  }

  Future<List<SimulacaoSolar>> listarTodos() async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query('SimulacaoSolar');
    return result.map((e) => SimulacaoSolar.fromMap(e)).toList();
  }

  Future<List<SimulacaoSolar>> listarPorUsuario(int usuarioId) async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query(
      'SimulacaoSolar',
      where: 'ID_Usuario = ?',
      whereArgs: [usuarioId],
    );
    return result.map((e) => SimulacaoSolar.fromMap(e)).toList();
  }
}
