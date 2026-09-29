import 'package:actividadsem6/presentation/pantallas/pantalla_ingreso.dart';
import 'package:actividadsem6/presentation/providers/perfiles_provider.dart';
import 'package:actividadsem6/presentation/providers/sesion_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PerfilesProvider>().cargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final perfilesProvider = context.watch<PerfilesProvider>();
    final sesion = context.watch<SesionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(
            tooltip: 'Recargar perfiles',
            onPressed: perfilesProvider.cargando
                ? null
                : () => context.read<PerfilesProvider>().cargar(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: sesion.cargando ? null : () => _cerrarSesion(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: sesion.error == null
          ? _contenido(perfilesProvider)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    sesion.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(child: _contenido(perfilesProvider)),
              ],
            ),
    );
  }

  Widget _contenido(PerfilesProvider provider) {
    if (provider.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            provider.error!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (provider.perfiles.isEmpty) {
      return const Center(child: Text('No hay perfiles disponibles.'));
    }

    return ListView.builder(
      itemCount: provider.perfiles.length,
      itemBuilder: (context, index) {
        final perfil = provider.perfiles[index];
        final fecha = perfil.creadoEn.toLocal().toIso8601String().split('T')[0];
        return ListTile(
          title: Text(perfil.nombre),
          subtitle: Text('Creado: $fecha'),
        );
      },
    );
  }

  Future<void> _cerrarSesion() async {
    await context.read<SesionProvider>().salir();
    if (!mounted) return;

    final sesion = context.read<SesionProvider>();
    if (sesion.idUsuario != null || sesion.error != null) return;

    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(builder: (_) => const PantallaIngreso()),
    );
  }
}
