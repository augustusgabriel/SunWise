import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

import '../database/dao/fornecedor_dao.dart';
import '../database/dao/fornecedor_solucoes_dao.dart';
import '../database/dao/usuario_dao.dart';
import '../database/dao/localizacao_dao.dart';
import '../models/fornecedor_model.dart';
import '../models/usuario_model.dart';
import '../providers/app_drawer.dart';
import '../providers/app_nav_bottom.dart';

class FornecedoresPage extends StatefulWidget {
  const FornecedoresPage({super.key});

  @override
  State<FornecedoresPage> createState() => _FornecedoresPageState();
}

class _FornecedoresPageState extends State<FornecedoresPage> {
  LatLng? _userLatLng;
  List<Fornecedor> fornecedoresProximos = [];
  String selectedFilter = "Todos";
  String? mensagemLocalizacao;
  final _searchController = TextEditingController();
  Usuario? usuario;

  @override
  void initState() {
    super.initState();
    // Delay necessário para acessar o ModalRoute após o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carregarUsuarioEIniciar();
    });
  }

  Future<void> _carregarUsuarioEIniciar() async {
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

    await _initLocationAndData();
  }

  Future<void> _initLocationAndData() async {
    if (usuario == null || usuario!.localizacaoId == null) {
      setState(() {
        _userLatLng = LatLng(-23.5505, -46.6333); // fallback
        mensagemLocalizacao = "Usando localização padrão (São Paulo)";
      });
      return;
    }

    final localizacao = await LocalizacaoDao().buscarPorId(usuario!.localizacaoId!);
    if (localizacao == null) {
      setState(() {
        _userLatLng = LatLng(-23.5505, -46.6333);
        mensagemLocalizacao = "Usando localização padrão (São Paulo)";
      });
      return;
    }

    final enderecoCompleto = "${localizacao.cidade}, ${localizacao.estado}, ${localizacao.cep}";

    try {
      List<Location> locations = await locationFromAddress(enderecoCompleto);
      if (locations.isNotEmpty) {
        _userLatLng = LatLng(locations.first.latitude, locations.first.longitude);
      } else {
        throw Exception("Endereço não encontrado");
      }
    } catch (e) {
      debugPrint('Erro ao converter endereço: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível localizar o endereço. Usando localização padrão.')),
      );
      _userLatLng = LatLng(-23.5505, -46.6333);
      mensagemLocalizacao = "Usando localização padrão (São Paulo)";
    }

    final solucoesDao = FornecedorSolucoesDao();
    final solucoes = await solucoesDao.listarPorLocalizacao(localizacao.cidade);

    final fornecedorDao = FornecedorDao();
    final todosFornecedores = await fornecedorDao.listarTodos();

    final ids = solucoes.map((s) => s.fornecedorId).toSet();
    fornecedoresProximos = todosFornecedores.where((f) => ids.contains(f.id)).toList();

    setState(() {});
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
        title: const Text("Mapeamento de Fornecedores"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      drawer: AppDrawer(
        usuario: usuario,
        onLogout: _logout,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: '/fornecedores'),
      body: _userLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: "Buscar por nome ou local",
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
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
                            onSelected: (_) => setState(() => selectedFilter = filter),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (mensagemLocalizacao != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        mensagemLocalizacao!,
                        style: TextStyle(color: Colors.orange[700]),
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: _userLatLng!,
                        initialZoom: 13,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: fornecedoresProximos.map((f) {
                            final lat = _userLatLng!.latitude + (0.01 - 0.02 * (f.id ?? 1) % 2);
                            final lng = _userLatLng!.longitude + (0.01 - 0.02 * (f.id ?? 1) % 3);
                            return Marker(
                              point: LatLng(lat, lng),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: Colors.red),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: fornecedoresProximos.length,
                      itemBuilder: (context, index) {
                        final f = fornecedoresProximos[index];
                        return Card(
                          child: ListTile(
                            title: Text(f.nome),
                            subtitle: Text(f.tipoServico),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                Text(f.avaliacao.toString()),
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