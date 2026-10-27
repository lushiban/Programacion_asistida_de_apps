import '../domain/estrategia_redondeo.dart';

class RedondeoExacto implements EstrategiaRedondeo {
  const RedondeoExacto();

  @override
  double redondear(double valor) {
    const correccionBinaria = 0.000000001;
    return ((valor * 100) + 0.5 + correccionBinaria).floorToDouble() / 100;
  }
}
