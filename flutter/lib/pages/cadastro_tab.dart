import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/localizacao_model.dart';
import '../models/usuario_model.dart';
import '../database/dao/localizacao_dao.dart';
import '../database/dao/usuario_dao.dart';

class CadastroTab extends StatefulWidget {
  final void Function(int)? onSwitchTab;

  const CadastroTab({super.key, this.onSwitchTab});

  @override
  State<CadastroTab> createState() => _CadastroTabState();
}

class _CadastroTabState extends State<CadastroTab> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _tipoContaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();

  void _cadastrarUsuario() async {
  if (!_formKey.currentState!.validate()) return;

  try {
    // Cria e salva localização
    final novaLocalizacao = Localizacao(
      cidade: _cidadeController.text,
      estado: _estadoController.text,
      cep: _cepController.text,
    );
    final localizacaoId = await LocalizacaoDao().inserir(novaLocalizacao);

    // Cria e salva usuário com ID da localização
    final novoUsuario = Usuario(
      nome: _nomeController.text,
      email: _emailController.text,
      senha: _senhaController.text,
      tipoConta: _tipoContaController.text,
      localizacaoId: localizacaoId,
    );
    final usuarioId = await UsuarioDao().inserirUsuario(novoUsuario);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuário cadastrado com sucesso! ID: $usuarioId')),
    );

    widget.onSwitchTab?.call(0); // Redireciona para aba de login
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao cadastrar: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _tipoContaController,
              decoration: const InputDecoration(labelText: 'Tipo de Conta (Residencial/Comercial)'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _cidadeController,
              decoration: const InputDecoration(labelText: 'Cidade'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _estadoController,
              decoration: const InputDecoration(labelText: 'Estado'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: _cepController,
              decoration: const InputDecoration(labelText: 'CEP'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cadastrarUsuario,
              child: const Text('Cadastrar'),
            ),
            const SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Já possui conta? ',
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: 'Faça login!',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => widget.onSwitchTab?.call(0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}