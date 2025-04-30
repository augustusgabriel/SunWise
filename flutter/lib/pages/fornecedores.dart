import 'package:flutter/material.dart';

class FornecedoresPage extends StatefulWidget {
  const FornecedoresPage({super.key});

  @override
  State<FornecedoresPage> createState() => _FornecedoresPageState();
}

class _FornecedoresPageState extends State<FornecedoresPage> {
  final _searchController = TextEditingController();

  final List<Map<String, dynamic>> mockSuppliers = [
    {
      "name": "SolarTech Soluções",
      "service": "Instalação de painéis",
      "rating": 4.5,
    },
    {
      "name": "EcoEnergia BR",
      "service": "Venda e manutenção",
      "rating": 4.2,
    },
  ];

  String selectedFilter = "Todos";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapeamento de Fornecedores"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de busca
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Buscar por nome ou local",
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),

            // Filtros mockados
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Todos", "Instalação", "Manutenção", "Venda"].map((filter) {
                  final isSelected = filter == selectedFilter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      selectedColor: colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected ? colorScheme.onPrimaryContainer : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Espaço para o mapa
            Container(
              height: 180,
              width: double.infinity,
              color: Colors.black12,
              alignment: Alignment.center,
              child: const Text("Mapa interativo (em breve)"),
            ),

            const SizedBox(height: 16),

            // Lista de fornecedores mockados
            Expanded(
              child: ListView.builder(
                itemCount: mockSuppliers.length,
                itemBuilder: (context, index) {
                  final supplier = mockSuppliers[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.business),
                      title: Text(supplier["name"]),
                      subtitle: Text(supplier["service"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(supplier["rating"].toString()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
