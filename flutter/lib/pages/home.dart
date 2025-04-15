import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              IconButton(onPressed: onPressed, icon: const Icon(Icons.person)),
              IconButton(onPressed: onPressed, icon: const Icon(Icons.settings)),
              IconButton(onPressed: onPressed, icon: const Icon(Icons.logout_outlined))
            ],
          ),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Olá, [Nome]! Vamos otimizar o uso de energia de forma inteligente e sustentável!"),
          ],
        ),
      ),
    );
  }
}