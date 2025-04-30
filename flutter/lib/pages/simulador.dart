import 'package:flutter/material.dart';

class SimuladorPage extends StatefulWidget {
  const SimuladorPage({super.key});

  @override
  State<SimuladorPage> createState() => _SimuladorPageState();
}

class _SimuladorPageState extends State<SimuladorPage> {
  final _averageConsumptionController = TextEditingController();
  final _cityController = TextEditingController();

  // Mock resultado
  final Map<String, String> mockResult = {
    "sistemaRecomendado": "5 kWp",
    "roi": "4,2 anos",
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simulador Solar"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Simule o sistema solar ideal para sua residência:",
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),

            // Formulário
            TextField(
              controller: _averageConsumptionController,
              decoration: const InputDecoration(
                labelText: "Consumo médio mensal (kWh)",
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "Cidade ou região",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Lógica de simulação será adicionada depois
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text("Simular"),
            ),
            const SizedBox(height: 24),

            const Divider(),

            // Resultado mockado
            Text(
              "Resultado da Simulação:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.solar_power),
                      title: const Text("Sistema Recomendado"),
                      subtitle: Text(mockResult["sistemaRecomendado"]!),
                    ),
                    ListTile(
                      leading: const Icon(Icons.trending_up),
                      title: const Text("Retorno sobre investimento (ROI)"),
                      subtitle: Text(mockResult["roi"]!),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
