import '../app_database.dart';
import '../../models/usuario_model.dart';

class UsuarioDao {
  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await DatabaseHelper.initDB();
    return await db.insert('Usuario', usuario.toMap());
  }

  Future<List<Usuario>> listarUsuarios() async {
    final db = await DatabaseHelper.initDB();
    final result = await db.query('Usuario');
    return result.map((e) => Usuario.fromMap(e)).toList();
  }
}
