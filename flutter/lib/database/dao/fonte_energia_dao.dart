import 'package:sqflite/sqflite.dart';
import '../../models/fonte_energia_model.dart';
import '../../database/app_database.dart';

class FonteEnergiaDao {
  Future<int> inserir(FonteEnergia fonte) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('FonteEnergia', fonte.toMap());
  }

  Future<List<FonteEnergia>> listarTodas() async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query('FonteEnergia');
    return result.map((e) => FonteEnergia.fromMap(e)).toList();
  }

  Future<bool> estaVazio() async {
    final db = await DatabaseHelper.initDB();
    final result = await db.rawQuery('SELECT COUNT(*) as total FROM FonteEnergia');
    final count = Sqflite.firstIntValue(result) ?? 0;
    return count == 0;
  }

  Future<void> limparTabela() async {
    final db = await DatabaseHelper.initDB();
    await db.delete('FonteEnergia');
  }
}
