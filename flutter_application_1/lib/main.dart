import 'package:flutter/material.dart';

import 'screens/ver_imagen_jpg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contador',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 64, 121, 154),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ver imagen del búho',
        shape: const RoundedRectangleBorder(),
        onPressed: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(builder: (context) => const VerImagenJPG()),
          );
        },
        child: const Text('ver imagen', style: TextStyle(fontSize: 10)),
      ),
      appBar: AppBar(
        title: const Text('Contador'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/buho_mojado.jpg',
                  height: 320,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 30),

                // Contador
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.displayMedium,
                ),

                const SizedBox(height: 20),

                // Botón para restablecer el contador
                ElevatedButton(
                  onPressed: _resetCounter,
                  child: const Text('Restablecer contador'),
                ),

                const SizedBox(height: 16),

                // Botón para incrementar el contador
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('Incrementar contador'),
                ),

                const SizedBox(height: 16),

                // Botón para disminuir el contador
                ElevatedButton(
                  onPressed: _decrementCounter,
                  child: const Text('Disminuir contador'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
