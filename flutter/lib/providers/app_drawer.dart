import 'package:flutter/material.dart';
import '../models/usuario_model.dart';

class AppDrawer extends StatelessWidget {
  final Usuario? usuario;
  final void Function(bool isDark) onThemeToggle;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.usuario,
    required this.onThemeToggle,
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
              onThemeToggle(!isCurrentlyLight);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text("Sair"),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
