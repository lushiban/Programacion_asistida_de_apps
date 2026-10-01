import '../domain/estrategia_redondeo.dart';

class RedondeoHaciaArriba implements EstrategiaRedondeo {
  const RedondeoHaciaArriba();

  @override
  double redondear(double valor) => valor.ceilToDouble();
}
