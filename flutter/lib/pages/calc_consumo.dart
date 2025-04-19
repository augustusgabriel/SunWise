import 'package:flutter/material.dart';

class CalculadoraPage extends StatelessWidget {
  const CalculadoraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Consumo')),
      body: const Center(
        child: Text('Aqui ficará a calculadora de consumo de energia.'),
      ),
    );
  }
}
