import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:flutter_test/flutter_test.dart';

import 'casos_de_prueba.dart';

void main() {
  const validarEntrada = ValidarEntrada();
  const calcularDivision = CalcularDivision();

  for (final caso in casos) {
    test(caso.nombre, () {
      final validacion = validarEntrada.ejecutar(
        montoTexto: caso.monto.isNaN ? 'abc' : caso.monto.toString(),
        personasTexto: caso.personas.toString(),
        propinaTexto: caso.propina.toString(),
      );

      if (caso.errorEsperado != null) {
        expect(validacion.esValido, isFalse);
        expect(validacion.mensajeError, caso.errorEsperado);
        expect(validacion.cuenta, isNull);
        return;
      }

      expect(validacion.esValido, isTrue);
      expect(validacion.mensajeError, isNull);

      final EstrategiaRedondeo estrategia;
      if (caso.modo == 'exacto') {
        estrategia = const RedondeoExacto();
      } else if (caso.modo == 'arriba') {
        estrategia = const RedondeoHaciaArriba();
      } else {
        fail('Modo de redondeo desconocido: ${caso.modo}');
      }

      final resultado = calcularDivision.ejecutar(
        validacion.cuenta!,
        estrategia,
      );

      expect(resultado.montoPorPersona, closeTo(caso.esperado!, 0.001));
    });
  }

  test('CalcularDivision sustituye estrategias respetando LSP', () {
    const cuenta = Cuenta(monto: 10, personas: 3, porcentajePropina: 0);
    const estrategias = <EstrategiaRedondeo>[
      RedondeoExacto(),
      RedondeoHaciaArriba(),
    ];

    final resultados = estrategias
        .map(
          (estrategia) =>
              calcularDivision.ejecutar(cuenta, estrategia).montoPorPersona,
        )
        .toList();

    expect(resultados[0], closeTo(3.33, 0.001));
    expect(resultados[1], closeTo(4.00, 0.001));
  });
}
