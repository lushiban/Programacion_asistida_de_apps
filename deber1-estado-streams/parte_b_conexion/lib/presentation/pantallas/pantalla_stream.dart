import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    super.key,
    required this.consultarConexion,
    required this.observarConexion,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ConexionCubit(consultarConexion, observarConexion)..iniciar(),
      child: const _ContenidoStream(),
    );
  }
}

class _ContenidoStream extends StatefulWidget {
  const _ContenidoStream();

  @override
  State<_ContenidoStream> createState() => _ContenidoStreamState();
}

class _ContenidoStreamState extends State<_ContenidoStream> {
  int _cantidadCambios = 0;

  String _textoEstado(EstadoConexion estado) {
    return switch (estado) {
      EstadoConexion.wifi => 'Wi-Fi',
      EstadoConexion.datosMoviles => 'Datos móviles',
      EstadoConexion.sinConexion => 'Sin conexión',
      EstadoConexion.otro => 'Otro',
    };
  }

  IconData _iconoEstado(EstadoConexion estado) {
    return switch (estado) {
      EstadoConexion.wifi => Icons.wifi,
      EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
      EstadoConexion.sinConexion => Icons.wifi_off,
      EstadoConexion.otro => Icons.device_hub,
    };
  }

  Color _colorEstado(EstadoConexion estado) {
    if (estado == EstadoConexion.sinConexion) {
      return Colors.red;
    }

    if (estado == EstadoConexion.otro) {
      return Colors.orange;
    }

    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConexionCubit, EstadoConexion>(
      listener: (context, estado) {
        setState(() {
          _cantidadCambios++;
        });
      },
      child: BlocBuilder<ConexionCubit, EstadoConexion>(
        builder: (context, estado) {
          final color = _colorEstado(estado);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_iconoEstado(estado), size: 88, color: color),
                  const SizedBox(height: 20),
                  Text(
                    _textoEstado(estado),
                    style: Theme.of(context).textTheme.headlineLarge
                        ?.copyWith(color: color),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text('Cambios recibidos: $_cantidadCambios'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
