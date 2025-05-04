import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database/dao/simulacao_solar_dao.dart';
import '../../models/simulacao_solar_model.dart';
import '../../models/usuario_model.dart';
import '../../providers/app_drawer.dart';
import '../../providers/app_nav_bottom.dart';
import '../../database/dao/usuario_dao.dart';

class SimuladorPage extends StatefulWidget {
  const SimuladorPage({super.key});

  @override
  State<SimuladorPage> createState() => _SimuladorPageState();
}

class _SimuladorPageState extends State<SimuladorPage> {
  final _averageConsumptionController = TextEditingController();
  final _cityController = TextEditingController();

  String? sistemaRecomendado;
  String? roi;
  Usuario? usuario;
  bool _usuarioCarregado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_usuarioCarregado) {
      _carregarUsuario();
      _usuarioCarregado = true;
    }
  }

  void _carregarUsuario() async {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Usuario) {
      setState(() {
        usuario = args;
      });
    } else {
      final usuarioLogado = await UsuarioDao().buscarUsuarioLogado();
      if (mounted) {
        setState(() {
          usuario = usuarioLogado;
        });
      }
    }
  }

  void _simular() async {
    final consumo = double.tryParse(_averageConsumptionController.text);
    final cidade = _cityController.text;

    if (consumo == null || cidade.isEmpty || usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os dados corretamente')),
      );
      return;
    }

    final economiaAnual = consumo * 12 * 0.8;
    final custoInicial = consumo * 100;
    final roiCalculado = custoInicial / economiaAnual;
    final String dataHoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final simulacao = SimulacaoSolar(
      consumoMensal: consumo,
      localizacao: cidade,
      roi: roiCalculado,
      economiaAnual: economiaAnual,
      usuarioId: usuario!.id!,
      dataSimulacao: dataHoje,
    );

    await SimulacaoSolarDao().inserir(simulacao);

    setState(() {
      sistemaRecomendado = "${(consumo / 100).toStringAsFixed(1)} kWp";
      roi = "${roiCalculado.toStringAsFixed(1)} anos";
    });

    _averageConsumptionController.clear();
    _cityController.clear();
  }

  Future<void> _logout() async {
    await UsuarioDao().limparUsuarioLogado();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simulador Solar"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: AppDrawer(
        usuario: usuario,
        onLogout: _logout,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: '/simulador'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Simule o sistema solar ideal para sua residência:",
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16),
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
              onPressed: usuario == null ? null : _simular,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text("Simular"),
            ),
            const SizedBox(height: 24),
            const Divider(),
            if (roi != null && sistemaRecomendado != null) ...[
              Text("Resultado da Simulação:", style: Theme.of(context).textTheme.titleMedium),
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
                        subtitle: Text(sistemaRecomendado!),
                      ),
                      ListTile(
                        leading: const Icon(Icons.trending_up),
                        title: const Text("Retorno sobre investimento (ROI)"),
                        subtitle: Text(roi!),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}