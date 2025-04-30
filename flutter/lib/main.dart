import 'package:flutter/material.dart';
import './pages/home.dart';
import './pages/calc_consumo.dart';
import './pages/fornecedores.dart';
import './pages/simulador.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Energia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFEBA17),
          secondary: Color(0xFF74512D),
          surface: Color(0xFFF8F4E1),
          onSurface: Colors.black,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFFF8F4E1),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFEBA17),
          secondary: Color(0xFF74512D),
          surface: Color(0xFF4E1F00),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFF4E1F00),
      ),
      themeMode: _themeMode,
      home: MyHomePage(
        title: 'Energia Sustentável',
        onThemeToggle: toggleTheme,
      ),
      routes: {
        '/home': (context) => MyHomePage(title: 'Energia Sustentável', onThemeToggle: (isDark) => true,),
        '/calculadora': (context) => CalculadoraPage(),
        '/simulador': (context) => SimuladorPage(),
        '/fornecedores': (context) => FornecedoresPage()
      },
    );
  }
}