import 'cuenta.dart';

class ResultadoValidacion {
  const ResultadoValidacion.valido(this.cuenta) : mensajeError = null;

  const ResultadoValidacion.invalido(this.mensajeError) : cuenta = null;

  final Cuenta? cuenta;
  final String? mensajeError;

  bool get esValido => cuenta != null;
}

class ValidarEntrada {
  const ValidarEntrada();

  ResultadoValidacion ejecutar({
    required String montoTexto,
    required String personasTexto,
    required String propinaTexto,
  }) {
    final monto = double.tryParse(montoTexto.trim());
    if (monto == null || !monto.isFinite || monto <= 0) {
      return const ResultadoValidacion.invalido('Monto inválido');
    }

    final personas = int.tryParse(personasTexto.trim());
    if (personas == null || personas < 1) {
      return const ResultadoValidacion.invalido(
        'Debe haber al menos una persona',
      );
    }

    final propina = double.tryParse(propinaTexto.trim());
    if (propina == null || !propina.isFinite || propina < 0) {
      return const ResultadoValidacion.invalido('Propina inválida');
    }

    return ResultadoValidacion.valido(
      Cuenta(monto: monto, personas: personas, porcentajePropina: propina),
    );
  }
}
