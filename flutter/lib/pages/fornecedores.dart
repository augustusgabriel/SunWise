import 'package:flutter/material.dart';

class FornecedoresPage extends StatelessWidget {
  const FornecedoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapeamento de Fornecedores')),
      body: const Center(
        child: Text('Aqui ficará o mapa com fornecedores e filtros.'),
      ),
    );
  }
}
