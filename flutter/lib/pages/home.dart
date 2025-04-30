import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
    required this.onThemeToggle,
  });

  final String title;
  final void Function(bool isDark) onThemeToggle;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String mockUserName = 'João'; // Nome mockado

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Nome do usuário
              ListTile(
                leading: const Icon(Icons.person),
                title: Text("Olá, $mockUserName!"),
              ),

              // Tema toggle (modo escuro/claro)
              ListTile(
                leading: const Icon(Icons.light_mode),
                title: const Text("Alternar tema"),
                onTap: () {
                  final isCurrentlyLight = brightness == Brightness.light;
                  widget.onThemeToggle(isCurrentlyLight); // Alterna o tema
                  Navigator.pop(context); // Fecha o drawer
                },
              ),

              // Logout sem ação
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text("Sair"),
                onTap: () {}, // Placeholder
              ),
            ],
          ),
        ),
      ),
       body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Olá, $mockUserName! Vamos otimizar o uso de energia de forma inteligente e sustentável!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.calculate),
                    tooltip: 'Calculadora de Consumo',
                    onPressed: () {
                      Navigator.pushNamed(context, '/calculadora');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.solar_power),
                    tooltip: 'Simulador Solar',
                    onPressed: () {
                      Navigator.pushNamed(context, '/simulador');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.map),
                    tooltip: 'Mapeamento de Fornecedores',
                    onPressed: () {
                      Navigator.pushNamed(context, '/fornecedores');
                    },
                  ),
                ],
            )
          ],
        ),
      ),
    );
  }
}