import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario_model.dart';
import './theme_provider.dart';

class AppDrawer extends StatelessWidget {
  final Usuario? usuario;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.usuario,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final nomeUsuario = usuario?.nome ?? "Usuário";

    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text("Olá, $nomeUsuario!"),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text("Alternar tema"),
            onTap: () {
              final isCurrentlyLight = brightness == Brightness.light;
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(isCurrentlyLight);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text("Sair"),
            onTap: () {
              Navigator.pop(context);
              onLogout(); 
            },
          ),
        ],
      ),
    );
  }
}
