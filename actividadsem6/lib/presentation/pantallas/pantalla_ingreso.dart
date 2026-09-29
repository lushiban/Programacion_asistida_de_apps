import 'package:actividadsem6/presentation/pantallas/pantalla_usuarios.dart';
import 'package:actividadsem6/presentation/providers/sesion_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PantallaIngreso extends StatefulWidget {
  const PantallaIngreso({super.key});

  @override
  State<PantallaIngreso> createState() => _PantallaIngresoState();
}

class _PantallaIngresoState extends State<PantallaIngreso> {
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  final _nombreController = TextEditingController();
  bool _navegacionProgramada = false;

  @override
  void dispose() {
    _correoController.dispose();
    _claveController.dispose();
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();

    if (sesion.idUsuario != null && !_navegacionProgramada) {
      _navegacionProgramada = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (context.read<SesionProvider>().idUsuario == null) {
          _navegacionProgramada = false;
          return;
        }
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(builder: (_) => const PantallaUsuarios()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ingresar o crear cuenta')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Correo'),
                ),
                TextField(
                  controller: _claveController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Clave'),
                ),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                const SizedBox(height: 24),
                if (sesion.cargando) ...[
                  const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 16),
                ],
                if (sesion.error != null) ...[
                  Text(
                    sesion.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: sesion.cargando
                      ? null
                      : () {
                          context.read<SesionProvider>().ingresar(
                            _correoController.text.trim(),
                            _claveController.text,
                          );
                        },
                  child: const Text('Ingresar'),
                ),
                OutlinedButton(
                  onPressed: sesion.cargando
                      ? null
                      : () {
                          context.read<SesionProvider>().registrar(
                            _correoController.text.trim(),
                            _claveController.text,
                            _nombreController.text.trim(),
                          );
                        },
                  child: const Text('Crear cuenta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
