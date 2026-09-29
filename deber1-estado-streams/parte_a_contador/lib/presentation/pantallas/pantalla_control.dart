import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({
    super.key,
    required this.valorInicial,
    required this.incrementar,
    required this.decrementar,
  });

  final int valorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador;

  @override
  void initState() {
    super.initState();
    _contador = widget.valorInicial;
  }

  Future<void> _incrementar() async {
    final nuevoValor = await widget.incrementar();

    if (!mounted) {
      return;
    }

    setState(() {
      _contador = nuevoValor;
    });
  }

  Future<void> _decrementar() async {
    final nuevoValor = await widget.decrementar();

    if (!mounted) {
      return;
    }

    setState(() {
      _contador = nuevoValor;
    });
  }

  void _volver() {
    Navigator.pop(context, _contador);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control del contador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contador: $_contador',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _incrementar,
                  child: const Text('+1'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _decrementar,
                  child: const Text('-1'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _volver, child: const Text('Volver')),
          ],
        ),
      ),
    );
  }
}
