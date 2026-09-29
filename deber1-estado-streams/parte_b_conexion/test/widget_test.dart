import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/main.dart';

class _ConexionRepositoryPrueba implements ConexionRepository {
  @override
  Future<EstadoConexion> consultarAhora() async => EstadoConexion.wifi;

  @override
  Stream<EstadoConexion> observarCambios() => const Stream.empty();
}

void main() {
  testWidgets('consulta y muestra una fotografía de la conexión', (
    tester,
  ) async {
    final repository = _ConexionRepositoryPrueba();
    final consultarConexion = ConsultarConexion(repository);
    final observarConexion = ObservarConexion(repository);

    await tester.pumpWidget(
      MyApp(
        consultarConexion: consultarConexion,
        observarConexion: observarConexion,
      ),
    );

    expect(find.text('Sin consultar'), findsOneWidget);
    expect(find.text('Última consulta: --:--:--'), findsOneWidget);

    await tester.tap(find.text('Consultar ahora'));
    await tester.pumpAndSettle();

    expect(find.text('Wi-Fi'), findsOneWidget);
    expect(find.text('Última consulta: --:--:--'), findsNothing);
  });
}
