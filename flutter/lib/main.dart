import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_tab_provider.dart';
import 'pages/login_register_page.dart';
import './pages/home.dart';
import 'pages/calc_page.dart';
import './pages/fornecedores.dart';
import './pages/simulador.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthTabProvider()),
      ],
      child: MyApp(),
    ),
  );
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
      title: 'SunWise',
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
          surface: Color(0xFF172138),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFF172138),
      ),
      themeMode: _themeMode,
      home: const LoginPage(),
      routes: {
        '/homepage': (context) =>
            MyHomePage(title: 'Energia Sustentável', onThemeToggle: (isDark) => true),
        '/calculadora': (context) => CalculadoraPage(onThemeToggle: (isDark) => true),
        '/simulador': (context) => SimuladorPage(onThemeToggle: (isDark) => true),
        '/fornecedores': (context) => FornecedoresPage(onThemeToggle: (isDark) => true),
      },
    );
  }
}