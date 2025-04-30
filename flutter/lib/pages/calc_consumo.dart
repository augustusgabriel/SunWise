import 'package:flutter/material.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final _deviceController = TextEditingController();
  final _powerController = TextEditingController();
  final _timeController = TextEditingController();

  // Lista mockada por enquanto
  final List<Map<String, String>> mockDevices = [
    {"name": "Geladeira", "power": "150W", "time": "24h"},
    {"name": "TV", "power": "100W", "time": "5h"},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de Consumo"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Insira os dados do dispositivo para calcular o consumo diário.",
              style: TextStyle(color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),

            // Formulário
            TextField(
              controller: _deviceController,
              decoration: const InputDecoration(labelText: "Nome do dispositivo"),
            ),
            TextField(
              controller: _powerController,
              decoration: const InputDecoration(labelText: "Potência (Watts)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: "Tempo de uso diário (horas)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Aqui depois colocamos a lógica de adicionar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text("Adicionar"),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Lista mockada
            Expanded(
              child: ListView.builder(
                itemCount: mockDevices.length,
                itemBuilder: (context, index) {
                  final device = mockDevices[index];
                  return ListTile(
                    leading: const Icon(Icons.bolt),
                    title: Text(device["name"] ?? ""),
                    subtitle: Text(
                      "Potência: ${device["power"]}, Uso diário: ${device["time"]}",
                    ),
                  );
                },
              ),
            ),

            // Espaço reservado para gráfico
            Container(
              height: 150,
              color: Colors.black12,
              alignment: Alignment.center,
              child: const Text("Gráfico de consumo (futuro)"),
            ),
          ],
        ),
      ),
    );
  }
}
