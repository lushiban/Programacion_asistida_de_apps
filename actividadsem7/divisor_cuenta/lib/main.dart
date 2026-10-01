import 'package:flutter/material.dart';

import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/estrategia_redondeo.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/formateador_moneda.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  runApp(const DivisorCuentaApp());
}

class DivisorCuentaApp extends StatelessWidget {
  const DivisorCuentaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final estrategias = <String, EstrategiaRedondeo>{
      'Exacto': const RedondeoExacto(),
      'Hacia arriba': const RedondeoHaciaArriba(),
    };
    final controller = DivisorController(
      validarEntrada: const ValidarEntrada(),
      calcularDivision: const CalcularDivision(),
      estrategias: estrategias,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dividir cuenta',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: PantallaDivisor(
        controller: controller,
        formateadorMoneda: const FormateadorMoneda(),
      ),
    );
  }
}
