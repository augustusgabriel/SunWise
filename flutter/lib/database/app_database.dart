import 'package:flutter/foundation.dart'; // Para verificar se é web
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = 'energia.db';
  static const _dbVersion = 1;

  static Future<Database> initDB() async {
    // Define o factory apropriado (web ou mobile)
    DatabaseFactory dbFactory;
    String dbPath;

    if (kIsWeb) {
      // Web: usa databaseFactoryFfiWeb e nome simples
      dbFactory = databaseFactoryFfiWeb;
      dbPath = _dbName;
    } else {
      // Mobile/Desktop: usa sqflite padrão
      dbFactory = databaseFactory;
      final path = await getDatabasesPath();
      dbPath = join(path, _dbName);
    }

    return dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        onCreate: (db, version) async {
          // LOCALIZAÇÃO
          await db.execute('''
            CREATE TABLE Localizacao (
              ID_Localizacao INTEGER PRIMARY KEY,
              Cidade TEXT,
              Estado TEXT,
              CEP TEXT
            )
          ''');

          // USUÁRIO
          await db.execute('''
            CREATE TABLE Usuario (
              ID_Usuario INTEGER PRIMARY KEY,
              Nome TEXT,
              Email TEXT,
              Senha TEXT,
              Tipo_Conta TEXT,
              Localizacao_Usuario INTEGER,
              FOREIGN KEY (Localizacao_Usuario) REFERENCES Localizacao(ID_Localizacao)
            )
          ''');

          // EQUIPAMENTO
          await db.execute('''
            CREATE TABLE Equipamento (
              ID_Equipamento INTEGER PRIMARY KEY,
              Nome TEXT,
              Potencia REAL,
              Tempo_uso_diario REAL,
              ID_Usuario INTEGER,
              FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
            )
          ''');

          // CÁLCULO DE CONSUMO
          await db.execute('''
            CREATE TABLE CalculoConsumo (
              ID_Calculo INTEGER PRIMARY KEY,
              Consumo_Total REAL,
              Custo_Total REAL,
              ID_Usuario INTEGER,
              Data_Calculo TEXT,
              FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
            )
          ''');

          // SUGESTÃO DE ECONOMIA
          await db.execute('''
            CREATE TABLE SugestaoEconomia (
              ID_Sugestao INTEGER PRIMARY KEY,
              Texto_Sugestao TEXT,
              Tipo_Sugestao TEXT,
              ID_Calculo INTEGER,
              FOREIGN KEY (ID_Calculo) REFERENCES CalculoConsumo(ID_Calculo)
            )
          ''');

          // SIMULAÇÃO SOLAR
          await db.execute('''
            CREATE TABLE SimulacaoSolar (
              ID_Simulacao INTEGER PRIMARY KEY,
              Consumo_Mensal REAL,
              Localizacao TEXT,
              ROI REAL,
              Economia_Anual REAL,
              ID_Usuario INTEGER,
              Data_Simulacao TEXT,
              FOREIGN KEY (ID_Usuario) REFERENCES Usuario(ID_Usuario)
            )
          ''');

          // FORNECEDORES
          await db.execute('''
            CREATE TABLE Fornecedores (
              ID_Fornecedor INTEGER PRIMARY KEY,
              Nome_Fornecedor TEXT,
              Tipo_Servico TEXT,
              Endereco TEXT,
              Telefone TEXT,
              Email TEXT,
              Avaliacao REAL
            )
          ''');

          // FORNECEDOR DE SOLUÇÕES
          await db.execute('''
            CREATE TABLE FornecedorSolucoes (
              ID_Fornecedor_Solucao INTEGER PRIMARY KEY,
              Tipo_Solucao TEXT,
              Custo_Instalacao REAL,
              Localizacao_Fornecedor TEXT,
              ID_Fornecedor INTEGER,
              FOREIGN KEY (ID_Fornecedor) REFERENCES Fornecedores(ID_Fornecedor)
            )
          ''');

          // FONTE DE ENERGIA RENOVÁVEL
          await db.execute('''
            CREATE TABLE FonteEnergia (
              ID_Fonte INTEGER PRIMARY KEY,
              Tipo TEXT,
              Descricao TEXT,
              Custo_Inicial REAL,
              Beneficios TEXT
            )
          ''');

          // TABELA DE RELACIONAMENTO N:M
          await db.execute('''
            CREATE TABLE FonteFornecedor (
              ID_Fonte INTEGER,
              ID_Fornecedor_Solucao INTEGER,
              PRIMARY KEY (ID_Fonte, ID_Fornecedor_Solucao),
              FOREIGN KEY (ID_Fonte) REFERENCES FonteEnergia(ID_Fonte),
              FOREIGN KEY (ID_Fornecedor_Solucao) REFERENCES FornecedorSolucoes(ID_Fornecedor_Solucao)
            )
          ''');
        },
      ),
    );
  }
}
