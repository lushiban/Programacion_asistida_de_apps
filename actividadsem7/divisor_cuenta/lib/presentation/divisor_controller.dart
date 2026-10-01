import '../domain/calcular_division.dart';
import '../domain/estrategia_redondeo.dart';
import '../domain/resultado.dart';
import '../domain/validar_entrada.dart';

class DivisorController {
  DivisorController({
    required ValidarEntrada validarEntrada,
    required CalcularDivision calcularDivision,
    required Map<String, EstrategiaRedondeo> estrategias,
  }) : _validarEntrada = validarEntrada,
       _calcularDivision = calcularDivision,
       _estrategias = Map.unmodifiable(estrategias),
       estrategiaSeleccionada = estrategias.keys.first;

  final ValidarEntrada _validarEntrada;
  final CalcularDivision _calcularDivision;
  final Map<String, EstrategiaRedondeo> _estrategias;

  String montoTexto = '';
  String personasTexto = '';
  String propinaTexto = '';
  String estrategiaSeleccionada;
  String? mensajeError;
  Resultado? resultado;

  List<String> get nombresEstrategias =>
      _estrategias.keys.toList(growable: false);

  void actualizarMonto(String valor) => montoTexto = valor;

  void actualizarPersonas(String valor) => personasTexto = valor;

  void actualizarPropina(String valor) => propinaTexto = valor;

  void seleccionarEstrategia(String nombre) {
    if (_estrategias.containsKey(nombre)) {
      estrategiaSeleccionada = nombre;
    }
  }

  void calcular() {
    mensajeError = null;

    final validacion = _validarEntrada.ejecutar(
      montoTexto: montoTexto,
      personasTexto: personasTexto,
      propinaTexto: propinaTexto,
    );

    if (!validacion.esValido) {
      resultado = null;
      mensajeError = validacion.mensajeError;
      return;
    }

    final estrategia = _estrategias[estrategiaSeleccionada]!;
    resultado = _calcularDivision.ejecutar(validacion.cuenta!, estrategia);
  }
}
