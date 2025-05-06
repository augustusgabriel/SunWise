import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/usuario_model.dart';
import '../models/fonte_energia_model.dart';
import '../database/dao/usuario_dao.dart';
import '../database/dao/fonte_energia_dao.dart';
import '../providers/app_drawer.dart';
import '../providers/app_nav_bottom.dart';
import '../providers/graficos_usuario.dart';
import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Usuario? usuarioLogado;
  List<FonteEnergia> fontesEnergia = [];
  final Map<String, String> linksEnergia = { // Mapeamento dos links
    'Solar': 'https://brasilescola.uol.com.br/geografia/energia-solar.htm',
    'Eólica': 'https://brasilescola.uol.com.br/fisica/energia-eolica.htm',
    'Hidrelétrica': 'https://brasilescola.uol.com.br/geografia/energia-hidreletrica.htm',
    'Biomassa': 'https://brasilescola.uol.com.br/geografia/biomassa.htm',
    'Geotérmica': 'https://brasilescola.uol.com.br/geografia/energia-geotermica-1.htm',
    'Maré': 'https://brasilescola.uol.com.br/geografia/energia-das-mares.htm#:~:text=Energia%20das%20mar%C3%A9s%2C%20ou%20energia,renov%C3%A1vel%2C%20que%20%C3%A9%20a%20%C3%A1gua.',
  };

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
    _carregarFontesEnergia();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Usuario && usuarioLogado == null) {
      setState(() {
        usuarioLogado = args;
      });
    }
  }

  Future<void> _carregarUsuarioLogado() async {
    final dao = UsuarioDao();
    final usuario = await dao.buscarUsuarioLogado();
    if (mounted && usuarioLogado == null) {
      setState(() {
        usuarioLogado = usuario;
      });
    }
  }

  Future<void> _carregarFontesEnergia() async {
    final dao = FonteEnergiaDao();

    final vazio = await dao.estaVazio();
    if (vazio) {
      final rawData = await rootBundle.loadString('lib/assets/fonte_energia.csv');

      List<List<dynamic>> linhas = CsvToListConverter().convert(rawData);

      
      final cabecalhos = linhas.first.map((e) => e.toString()).toList();

      
      for (final linha in linhas.skip(1)) {
        final linhaStrings = linha.map((e) => e.toString()).toList();

        
        final mapa = Map<String, String>.fromIterables(cabecalhos, linhaStrings);

        final fonte = FonteEnergia(
          tipo: mapa['Tipo'] ?? '',
          descricao: mapa['Descricao'] ?? '',
          custoInicial: double.tryParse(mapa['Custo_Inicial'] ?? '0') ?? 0.0,
          beneficios: mapa['Beneficios'] ?? '',
        );
        await dao.inserir(fonte);
      }
    }

    final todasFontes = await dao.listarTodas();
    setState(() {
      fontesEnergia = todasFontes;
    });
  }


  Future<void> _logout() async {
    final dao = UsuarioDao();
    await dao.limparUsuarioLogado();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nomeUsuario = usuarioLogado?.nome ?? 'Usuário';
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: theme.colorScheme.onPrimary)),
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      drawer: AppDrawer(
        usuario: usuarioLogado,
        onLogout: _logout,
      ),
      bottomNavigationBar: const AppBottomNavBar(currentRoute: '/homepage'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Olá, $nomeUsuario! Vamos otimizar o uso de energia de forma inteligente e sustentável!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 20),

            // Label com botão de expandir/colapsar
            ExpansionTile(
              title: Text(
                "Aprenda sobre Fontes Renováveis",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              children: fontesEnergia.map((fonte) => Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black, width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fonte.tipo,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          )),
                      const SizedBox(height: 8),
                      Text(
                        fonte.descricao,
                        style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Custo Inicial: R\$ ${fonte.custoInicial.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Benefícios: ${fonte.beneficios}",
                        style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () async {
                            final url = linksEnergia[fonte.tipo];
                            if (url != null) {
                              try {
                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                              } catch (e) {
                                debugPrint("Erro ao abrir link: $e");
                              }
                            }
                          },
                          child: const Text('Saiba mais'),
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 32),
            const GraficosEnergia(),
          ],
        ),
      ),
    );
  }
}
