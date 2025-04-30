import '../../models/equipamento_model.dart';
import '../../database/app_database.dart';

class EquipamentoDao {
  Future<int> inserirEquipamento(Equipamento equipamento) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('Equipamento', equipamento.toMap());
  }

  Future<List<Equipamento>> listarPorUsuario(int usuarioId) async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query(
      'Equipamento',
      where: 'ID_Usuario = ?',
      whereArgs: [usuarioId],
    );
    return result.map((e) => Equipamento.fromMap(e)).toList();
  }
}
