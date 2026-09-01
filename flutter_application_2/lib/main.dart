import 'package:flutter/material.dart';

import 'spotify_example_page.dart';

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
          seedColor: const Color.fromARGB(255, 4, 14, 6),
        ),
        useMaterial3: true,
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

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                const Text(
                  '¿Cuántos gatos de 3 patas puedes contar?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                Icon(
                  Icons.pets,
                  size: 160,
                  color: Theme.of(context).colorScheme.primary,
                  semanticLabel: 'Ilustración de gatos',
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

                const SizedBox(height: 24),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const SpotifyExamplePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.music_note),
                  label: const Text('Abrir ejemplo de Spotify'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
