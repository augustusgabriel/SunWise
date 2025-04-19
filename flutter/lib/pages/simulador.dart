import 'package:flutter/material.dart';

class SimuladorPage extends StatelessWidget {
  const SimuladorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulador de Instalação Solar')),
      body: const Center(
        child: Text('Aqui ficará o simulador de sistema solar e ROI.'),
      ),
    );
  }
}
