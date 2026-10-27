import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

class CalcularDivision {
  const CalcularDivision();

  Resultado ejecutar(Cuenta cuenta, EstrategiaRedondeo estrategia) {
    final totalConPropina = cuenta.monto * (1 + cuenta.porcentajePropina / 100);
    final montoIndividual = totalConPropina / cuenta.personas;

    return Resultado(montoPorPersona: estrategia.redondear(montoIndividual));
  }
}
