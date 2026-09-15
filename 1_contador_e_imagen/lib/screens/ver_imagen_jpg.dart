import 'package:flutter/material.dart';

class VerImagenJPG extends StatelessWidget {
  const VerImagenJPG({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      // Bloquea el retroceso del sistema; el botón usa Navigator.pop directamente.
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 80,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/buho_mojado.jpg',
                    fit: BoxFit.contain,
                    semanticLabel: 'Búho mojado',
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: FloatingActionButton(
                  tooltip: 'Volver a la pantalla principal',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: const CircleBorder(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
