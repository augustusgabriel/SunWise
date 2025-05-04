import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/equipamento_model.dart';
import '../../database/dao/equipamento_dao.dart';
import '../../models/calculo_consumo_model.dart';
import '../../database/dao/calculo_consumo_dao.dart';
import '../../models/usuario_model.dart';
import '../../database/dao/usuario_dao.dart';
import '../../providers/app_drawer.dart';
import '../../providers/app_nav_bottom.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key,});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  final _deviceController = TextEditingController();
  final _powerController = TextEditingController();
  final _timeController = TextEditingController();
  final CalculoConsumoDao _calculoDao = CalculoConsumoDao();
  final double _custoPorKWh = 0.57;
  double _consumoTotalDiario = 0.0;
  double _custoTotalDiario = 0.0;
  final EquipamentoDao _equipamentoDao = EquipamentoDao();
  Usuario? usuarioLogado;
  bool _carregandoUsuario = true;
  List<Equipamento> equipamentos = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarUsuarioLogado() async {
    final dao = UsuarioDao();
    final usuario = await dao.buscarUsuarioLogado();

    if (mounted) {
      setState(() {
        usuarioLogado = usuario;
        _carregandoUsuario = false;
      });
      _carregarEquipamentos();
    }
  }


  Future<void> _carregarEquipamentos() async {
  if (usuarioLogado == null) return;
  final lista = await _equipamentoDao.listarPorUsuario(usuarioLogado!.id!);
  
  final consumoTotal = lista.fold(
    0.0,
    (soma, e) => soma + (e.potencia * e.tempoUsoDiario / 1000),
  );

  final custoTotal = consumoTotal * _custoPorKWh;

  setState(() {
    equipamentos = lista;
    _consumoTotalDiario = consumoTotal;
    _custoTotalDiario = custoTotal;
  });
}


  Future<void> _adicionarEquipamento() async {
    final nome = _deviceController.text.trim();
    final potencia = double.tryParse(_powerController.text.trim());
    final tempo = double.tryParse(_timeController.text.trim());

    if (nome.isEmpty || potencia == null || tempo == null || usuarioLogado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos corretamente.")),
      );
      return;
    }

    final equipamento = Equipamento(
      nome: nome,
      potencia: potencia,
      tempoUsoDiario: tempo,
      usuarioId: usuarioLogado!.id!,
    );

    await _equipamentoDao.inserirEquipamento(equipamento);

    _deviceController.clear();
    _powerController.clear();
    _timeController.clear();

    await _carregarEquipamentos();

    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final novoCalculo = CalculoConsumo(
      consumoTotal: _consumoTotalDiario,
      custoTotal: _custoTotalDiario,
      usuarioId: usuarioLogado!.id!,
      dataCalculo: hoje,
    );

    await _calculoDao.inserir(novoCalculo);

    setState(() {}); // Força rebuild
  }


  Future<void> _logout() async {
    final dao = UsuarioDao();
    await dao.limparUsuarioLogado();
    if (mounted) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(); // Tenta fechar o Drawer
      }
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  Widget _buildFormulario(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text("Insira os dados do dispositivo para calcular o consumo diário."),
          const SizedBox(height: 16),
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
            onPressed: usuarioLogado == null ? null : _adicionarEquipamento,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text("Adicionar"),
          ),
          const SizedBox(height: 24),
          const Divider(),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  "Consumo total diário: ${_consumoTotalDiario.toStringAsFixed(2)} kWh",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Custo diário estimado: R\$ ${_custoTotalDiario.toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_carregandoUsuario) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora de Consumo"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: AppDrawer(
        usuario: usuarioLogado,
        onLogout: _logout,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: '/calculadora'),
      body: _buildFormulario(colorScheme),
    );
  }
}