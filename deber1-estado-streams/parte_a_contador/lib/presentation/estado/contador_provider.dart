import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final obtenerContadorProvider = Provider<ObtenerContador>((ref) {
  throw UnimplementedError('ObtenerContador debe configurarse en main.dart');
});

final incrementarProvider = Provider<Incrementar>((ref) {
  throw UnimplementedError('Incrementar debe configurarse en main.dart');
});

final decrementarProvider = Provider<Decrementar>((ref) {
  throw UnimplementedError('Decrementar debe configurarse en main.dart');
});

final contadorProvider = NotifierProvider<ContadorNotifier, int>(
  ContadorNotifier.new,
);

class ContadorNotifier extends Notifier<int> {
  @override
  int build() => 0;

  Future<void> cargar() async {
    state = await ref.read(obtenerContadorProvider)();
  }

  Future<void> incrementar() async {
    state = await ref.read(incrementarProvider)();
  }

  Future<void> decrementar() async {
    state = await ref.read(decrementarProvider)();
  }
}
