import 'package:flutter/material.dart';
import '../models/localizacao_model.dart';
import '../models/usuario_model.dart';
import '../database/dao/localizacao_dao.dart';
import '../database/dao/usuario_dao.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _tipoContaController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();

  void _cadastrarUsuario() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;
    final tipoConta = _tipoContaController.text;
    final cidade = _cidadeController.text;
    final estado = _estadoController.text;
    final cep = _cepController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty || tipoConta.isEmpty || cidade.isEmpty || estado.isEmpty || cep.isEmpty) {
      // Mostrar mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    // Inserir Localização
    final localizacaoDao = LocalizacaoDao();
    final novaLocalizacao = Localizacao(cidade: cidade, estado: estado, cep: cep);
    int localizacaoId = await localizacaoDao.inserir(novaLocalizacao);

    // Inserir Usuário
    final usuarioDao = UsuarioDao();
    final novoUsuario = Usuario(
      nome: nome,
      email: email,
      senha: senha,
      tipoConta: tipoConta,
      localizacaoId: localizacaoId,
    );
    int usuarioId = await usuarioDao.inserirUsuario(novoUsuario);

    // Exibir mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuário cadastrado com ID: $usuarioId')),
    );

    // Limpar os campos após o cadastro
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _tipoContaController.clear();
    _cidadeController.clear();
    _estadoController.clear();
    _cepController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _tipoContaController,
                decoration: InputDecoration(labelText: 'Tipo de Conta (Residencial/Comercial)'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _cidadeController,
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: 'CEP'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cadastrarUsuario,
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
