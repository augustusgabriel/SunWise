import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_tab_provider.dart';
import './providers/theme_provider.dart';
import 'pages/login_register_page.dart';
import 'pages/home.dart';
import 'pages/calc_page.dart';
import 'pages/fornecedores.dart';
import 'pages/simulador.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthTabProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SunWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFFEBA17),
          onPrimary: Colors.black,
          secondary: Color(0xFF74512D),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Color(0xFFF8F4E1),
          onSurface: Colors.black,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFEBA17),
          onPrimary: Colors.black,
          secondary: Color(0xFF74512D),
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.black,
          surface: Color(0xFF172138),
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
      themeMode: themeProvider.themeMode,
      onGenerateRoute: (settings) {

        Widget page;

        switch (settings.name) {
          case '/homepage':
            page = MyHomePage(title: 'Energia Sustentável');
            break;
          case '/calculadora':
            page = CalculadoraPage();
            break;
          case '/simulador':
            page = SimuladorPage();
            break;
          case '/fornecedores':
            page = FornecedoresPage();
            break;
          case '/login':
          default:
            page = const LoginPage();
        }

        return MaterialPageRoute(
          builder: (_) => page,
          settings: settings,
        );
      },
    );
  }
}
