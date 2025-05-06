import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../database/dao/calculo_consumo_dao.dart';
import '../../database/dao/simulacao_solar_dao.dart';
import '../../models/calculo_consumo_model.dart';
import '../../models/simulacao_solar_model.dart';

class GraficosEnergia extends StatefulWidget {
  const GraficosEnergia({super.key});

  @override
  State<GraficosEnergia> createState() => _GraficosEnergiaState();
}

class _GraficosEnergiaState extends State<GraficosEnergia> {
  final CalculoConsumoDao _calculoDao = CalculoConsumoDao();
  final SimulacaoSolarDao _simulacaoDao = SimulacaoSolarDao();

  List<CalculoConsumo> _consumos = [];
  List<SimulacaoSolar> _simulacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final consumos = await _calculoDao.listarTodos();
    final simulacoes = await _simulacaoDao.listarTodos();
    setState(() {
      _consumos = consumos;
      _simulacoes = simulacoes;
    });
  }

  List<FlSpot> _gerarProjecaoEconomia(List<SimulacaoSolar> dados) {
    if (dados.length < 2) return [];

    final anosExtras = 5;
    final spots = dados.asMap().entries.map((e) =>
        FlSpot(e.key.toDouble(), e.value.economiaAnual)).toList();

    final n = spots.length;
    final xSum = spots.map((e) => e.x).reduce((a, b) => a + b);
    final ySum = spots.map((e) => e.y).reduce((a, b) => a + b);
    final xySum = spots.map((e) => e.x * e.y).reduce((a, b) => a + b);
    final x2Sum = spots.map((e) => e.x * e.x).reduce((a, b) => a + b);

    final m = (n * xySum - xSum * ySum) / (n * x2Sum - xSum * xSum);
    final b = (ySum - m * xSum) / n;

    return List.generate(anosExtras, (i) {
      final x = n + i.toDouble();
      final y = m * x + b;
      return FlSpot(x, y);
    });
  }

  Widget _graficoBox(String titulo, Widget grafico) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
          ),
          height: 250,
          child: grafico,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _graficoBox(
            "Seu Consumo Diário (kWh)",
            BarChart(
              BarChartData(
                barGroups: _consumos.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value.consumoTotal,
                        color: Colors.blueAccent,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, _) =>
                          Text('D${value.toInt() + 1}', style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, _) => Text('${value.toStringAsFixed(1)}'),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          ),
          _graficoBox(
            "Economia de Energia Anual (R\$)",
            LineChart(
              LineChartData(
                minY: 0,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) =>
                          Text('Ano ${value.toInt() + 1}', style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) =>
                          Text('R\$${value.toInt()}', style: const TextStyle(fontSize: 10)),
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 3,
                    spots: _simulacoes.asMap().entries.map((e) =>
                        FlSpot(e.key.toDouble(), e.value.economiaAnual)).toList(),
                  ),
                  // Linha de projeção futura
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.greenAccent,
                    barWidth: 2,
                    dashArray: [5, 5],
                    spots: _gerarProjecaoEconomia(_simulacoes),
                  ),
                ],
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
