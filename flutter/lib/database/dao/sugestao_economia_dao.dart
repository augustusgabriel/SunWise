import '../../models/sugestao_economia_model.dart';
import '../../database/app_database.dart';

class SugestaoEconomiaDao {
  Future<int> inserir(SugestaoEconomia sugestao) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('SugestaoEconomia', sugestao.toMap());
  }

  Future<List<SugestaoEconomia>> listarPorCalculo(int calculoId) async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query(
      'SugestaoEconomia',
      where: 'ID_Calculo = ?',
      whereArgs: [calculoId],
    );
    return result.map((e) => SugestaoEconomia.fromMap(e)).toList();
  }
}
