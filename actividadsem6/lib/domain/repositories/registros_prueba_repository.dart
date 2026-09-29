import 'package:actividadsem6/domain/entities/registro_prueba.dart';

abstract class RegistrosPruebaRepository {
  Future<List<RegistroPrueba>> obtenerTodos();
}
