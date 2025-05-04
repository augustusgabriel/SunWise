import 'package:shared_preferences/shared_preferences.dart';
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

  Future<Usuario?> buscarPorEmailESenha(String email, String senha) async {
  final db = await DatabaseHelper.initDB();
  final maps = await db.query(
    'Usuario',
    where: 'Email = ? AND Senha = ?',
    whereArgs: [email, senha],
  );

  if (maps.isNotEmpty) {
    return Usuario.fromMap(maps.first);
  } else {
    return null;
  }
}

Future<void> salvarUsuarioLogado(int usuarioId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('usuarioLogadoId', usuarioId);
}

Future<Usuario?> buscarUsuarioLogado() async {
  final prefs = await SharedPreferences.getInstance();
  final usuarioId = prefs.getInt('usuarioLogadoId');

  if (usuarioId == null) {
    return null;
  }

  final db = await DatabaseHelper.initDB();
  final maps = await db.query(
    'Usuario',
    where: 'ID_Usuario = ?',
    whereArgs: [usuarioId],
  );

  if (maps.isNotEmpty) {
    return Usuario.fromMap(maps.first);
  } else {
    return null;
  }
}

Future<void> limparUsuarioLogado() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('usuarioLogadoId');
}

}
