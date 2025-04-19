import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final void Function(ThemeMode)? onThemeChanged;

  const MyHomePage({
    super.key,
    required this.title,
    this.onThemeChanged,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Perfil do Usuário
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Olá, João Silva!'), // Nome mockado
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perfil do usuário (ainda em construção)')),
                  );
                },
              ),
              const Divider(),
              // Configurações
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configurações'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Estilo do App'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.light_mode),
                              title: const Text('Modo Claro'),
                              onTap: () {
                                Navigator.pop(context);
                                widget.onThemeChanged?.call(ThemeMode.light);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.dark_mode),
                              title: const Text('Modo Escuro'),
                              onTap: () {
                                Navigator.pop(context);
                                widget.onThemeChanged?.call(ThemeMode.dark);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const Divider(),
              // Logout (sem ação por enquanto)
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Sair'),
                onTap: () {
                  // Nenhuma ação ainda
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Olá, [Nome]! Vamos otimizar o uso de energia de forma inteligente e sustentável!"),
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