import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';
import 'pantalla_control.dart';

class PantallaVisor extends ConsumerStatefulWidget {
  const PantallaVisor({super.key});

  @override
  ConsumerState<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends ConsumerState<PantallaVisor> {
  @override
  void initState() {
    super.initState();
    ref.read(contadorProvider.notifier).cargar();
  }

  @override
  Widget build(BuildContext context) {
    final contador = ref.watch(contadorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Visor del contador')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contador: $contador',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PantallaControl(),
                  ),
                );
              },
              child: const Text('Ir a Control'),
            ),
          ],
        ),
      ),
    );
  }
}
