import 'package:actividadsem6/presentation/pantallas/pantalla_ingreso.dart';
import 'package:actividadsem6/presentation/providers/registros_prueba_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RegistrosPruebaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla_prueba'),
        actions: [
          IconButton(
            tooltip: 'Ingresar o crear cuenta',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PantallaIngreso(),
                ),
              );
            },
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            tooltip: 'Actualizar',
            onPressed: provider.cargando ? null : provider.cargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, RegistrosPruebaProvider provider) {
    if (provider.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargar,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.registros.isEmpty) {
      return const Center(child: Text('No hay registros disponibles.'));
    }

    return RefreshIndicator(
      onRefresh: provider.cargar,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.registros.length,
        itemBuilder: (context, index) {
          final registro = provider.registros[index];
          final fecha = registro.creadoEn?.toUtc().toIso8601String();
          return ListTile(
            title: Text('ID: ${registro.id}'),
            subtitle: Text(
              fecha == null ? 'Fecha no disponible' : 'Creado (UTC): $fecha',
            ),
          );
        },
      ),
    );
  }
}
