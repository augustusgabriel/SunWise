import 'package:flutter/material.dart';
import '../models/usuario_model.dart';
import '../database/dao/usuario_dao.dart';
import '../providers/app_drawer.dart';
import '../providers/app_nav_bottom.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Usuario? usuarioLogado;

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado(); // fallback, caso não venha via argumentos
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Usuario && usuarioLogado == null) {
      setState(() {
        usuarioLogado = args;
      });
    }
  }

  Future<void> _carregarUsuarioLogado() async {
    final dao = UsuarioDao();
    final usuario = await dao.buscarUsuarioLogado();
    if (mounted && usuarioLogado == null) {
      setState(() {
        usuarioLogado = usuario;
      });
    }
  }

  Future<void> _logout() async {
    final dao = UsuarioDao();
    await dao.limparUsuarioLogado();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nomeUsuario = usuarioLogado?.nome ?? 'Usuário';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: theme.colorScheme.onPrimary)),
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      drawer: AppDrawer(
        usuario: usuarioLogado,
        onLogout: _logout,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: '/homepage'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            "Olá, $nomeUsuario! Vamos otimizar o uso de energia de forma inteligente e sustentável!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface),
          ),
        ),
      ),
    );
  }
}
