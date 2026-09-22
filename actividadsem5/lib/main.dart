import 'package:flutter/widgets.dart';

import 'data/repositories/usuario_memoria.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';
import 'presentation/app.dart';

void main() {
  final usuarioMemoria = UsuarioMemoria();
  final obtenerUsuariosConVocal = ObtenerUsuariosConVocal(usuarioMemoria);

  runApp(MyApp(obtenerUsuariosConVocal: obtenerUsuariosConVocal));
}
