import 'package:flutter/material.dart';

import 'divisor_controller.dart';
import 'formateador_moneda.dart';

class PantallaDivisor extends StatefulWidget {
  const PantallaDivisor({
    super.key,
    required this.controller,
    required this.formateadorMoneda,
  });

  final DivisorController controller;
  final FormateadorMoneda formateadorMoneda;

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  void _calcular() {
    setState(widget.controller.calcular);
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Dividir cuenta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const Key('monto'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Monto total'),
                    onChanged: controller.actualizarMonto,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('personas'),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Número de personas',
                    ),
                    onChanged: controller.actualizarPersonas,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('propina'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Porcentaje de propina',
                    ),
                    onChanged: controller.actualizarPropina,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: const Key('modoRedondeo'),
                    initialValue: controller.estrategiaSeleccionada,
                    decoration: const InputDecoration(
                      labelText: 'Modo de redondeo',
                    ),
                    items: controller.nombresEstrategias
                        .map(
                          (nombre) => DropdownMenuItem(
                            value: nombre,
                            child: Text(nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (nombre) {
                      if (nombre == null) {
                        return;
                      }
                      setState(() => controller.seleccionarEstrategia(nombre));
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('calcular'),
                    onPressed: _calcular,
                    child: const Text('Calcular'),
                  ),
                  if (controller.mensajeError case final mensaje?) ...[
                    const SizedBox(height: 20),
                    Text(
                      mensaje,
                      key: const Key('mensajeError'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  if (controller.resultado case final resultado?) ...[
                    const SizedBox(height: 28),
                    const Text(
                      'Cada persona paga',
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.formateadorMoneda.formatear(
                        resultado.montoPorPersona,
                      ),
                      key: const Key('resultado'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
