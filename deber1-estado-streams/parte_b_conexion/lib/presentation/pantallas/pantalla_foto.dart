import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({super.key, required this.consultarConexion});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion? _estadoConexion;
  DateTime? _horaConsulta;
  bool _consultando = false;

  Future<void> _consultarAhora() async {
    setState(() {
      _consultando = true;
    });

    final estado = await widget.consultarConexion();
    final hora = DateTime.now();

    if (!mounted) {
      return;
    }

    setState(() {
      _estadoConexion = estado;
      _horaConsulta = hora;
      _consultando = false;
    });
  }

  String _textoEstado(EstadoConexion? estado) {
    return switch (estado) {
      EstadoConexion.wifi => 'Wi-Fi',
      EstadoConexion.datosMoviles => 'Datos móviles',
      EstadoConexion.sinConexion => 'Sin conexión',
      EstadoConexion.otro => 'Otro',
      null => 'Sin consultar',
    };
  }

  IconData _iconoEstado(EstadoConexion? estado) {
    return switch (estado) {
      EstadoConexion.wifi => Icons.wifi,
      EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
      EstadoConexion.sinConexion => Icons.wifi_off,
      EstadoConexion.otro => Icons.device_hub,
      null => Icons.help_outline,
    };
  }

  Color _colorEstado(EstadoConexion? estado) {
    if (estado == null) {
      return Colors.grey;
    }

    if (estado == EstadoConexion.sinConexion) {
      return Colors.red;
    }

    return Colors.green;
  }

  String _formatearHora(DateTime? hora) {
    if (hora == null) {
      return '--:--:--';
    }

    String dosDigitos(int valor) => valor.toString().padLeft(2, '0');

    return '${dosDigitos(hora.hour)}:'
        '${dosDigitos(hora.minute)}:'
        '${dosDigitos(hora.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorEstado(_estadoConexion);

    return Scaffold(
      appBar: AppBar(title: const Text('Conexión - versión Future')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_iconoEstado(_estadoConexion), size: 88, color: color),
              const SizedBox(height: 20),
              Text(
                _textoEstado(_estadoConexion),
                style: Theme.of(context).textTheme.headlineLarge
                    ?.copyWith(color: color),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text('Última consulta: ${_formatearHora(_horaConsulta)}'),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _consultando ? null : _consultarAhora,
                icon: const Icon(Icons.refresh),
                label: Text(
                  _consultando ? 'Consultando...' : 'Consultar ahora',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
