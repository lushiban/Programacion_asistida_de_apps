import '../repositories/contador_repository.dart';

class Incrementar {
  const Incrementar(this._repository);

  final ContadorRepository _repository;

  Future<int> call() async {
    final valorActual = await _repository.leer();
    final nuevoValor = valorActual + 1;
    await _repository.guardar(nuevoValor);
    return nuevoValor;
  }
}
