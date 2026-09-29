import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/main.dart';

class _ContadorRepositoryPrueba implements ContadorRepository {
  int _valor = 0;

  @override
  Future<void> guardar(int valor) async {
    _valor = valor;
  }

  @override
  Future<int> leer() async => _valor;
}

void main() {
  testWidgets('navega al control e incrementa el contador', (tester) async {
    final repository = _ContadorRepositoryPrueba();

    await tester.pumpWidget(
      MyApp(
        obtenerContador: ObtenerContador(repository),
        incrementar: Incrementar(repository),
        decrementar: Decrementar(repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Contador: 0'), findsOneWidget);

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();

    expect(find.text('Contador: 1'), findsOneWidget);

    await tester.tap(find.text('Volver'));
    await tester.pumpAndSettle();

    expect(find.text('Contador: 1'), findsOneWidget);
  });
}
