import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/equipamento_model.dart';
import '../../database/dao/equipamento_dao.dart';
import '../../models/calculo_consumo_model.dart';
import '../../database/dao/calculo_consumo_dao.dart';


class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final _deviceController = TextEditingController();
  final _powerController = TextEditingController();
  final _timeController = TextEditingController();
  final CalculoConsumoDao _calculoDao = CalculoConsumoDao();
  final double _custoPorKWh = 0.75;


  final EquipamentoDao _equipamentoDao = EquipamentoDao();
  List<Equipamento> equipamentos = [];

  final int _usuarioId = 1; // mockado

  @override
  void initState() {
    super.initState();
    _carregarEquipamentos();
  }

  Future<void> _carregarEquipamentos() async {
    final lista = await _equipamentoDao.listarPorUsuario(_usuarioId);
    setState(() {
      equipamentos = lista;
    });
  }

  Future<void> _adicionarEquipamento() async {
  if (_deviceController.text.isEmpty ||
      _powerController.text.isEmpty ||
      _timeController.text.isEmpty) return;

  final equipamento = Equipamento(
    nome: _deviceController.text,
    potencia: double.tryParse(_powerController.text) ?? 0.0,
    tempoUsoDiario: double.tryParse(_timeController.text) ?? 0.0,
    usuarioId: _usuarioId,
  );

  await _equipamentoDao.inserirEquipamento(equipamento);

  _deviceController.clear();
  _powerController.clear();
  _timeController.clear();

  await _carregarEquipamentos();

  final consumoTotal = _calcularConsumoTotal();
  final custoTotal = consumoTotal * _custoPorKWh;

  final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final novoCalculo = CalculoConsumo(
    consumoTotal: consumoTotal,
    custoTotal: custoTotal,
    usuarioId: _usuarioId,
    dataCalculo: hoje,
  );

  await _calculoDao.inserir(novoCalculo);
}


  double _calcularConsumoTotal() {
    return equipamentos.fold(0.0, (soma, e) => soma + (e.potencia * e.tempoUsoDiario / 1000)); // em kWh
  }

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
            Text("Insira os dados do dispositivo para calcular o consumo diário."),
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
              onPressed: _adicionarEquipamento,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: const Text("Adicionar"),
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Lista de equipamentos
            Expanded(
              child: ListView.builder(
                itemCount: equipamentos.length,
                itemBuilder: (context, index) {
                  final e = equipamentos[index];
                  return ListTile(
                    leading: const Icon(Icons.bolt),
                    title: Text(e.nome),
                    subtitle: Text("Potência: ${e.potencia}W, Uso diário: ${e.tempoUsoDiario}h"),
                  );
                },
              ),
            ),

            // Resultado do consumo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Consumo total diário: ${_calcularConsumoTotal().toStringAsFixed(2)} kWh",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
