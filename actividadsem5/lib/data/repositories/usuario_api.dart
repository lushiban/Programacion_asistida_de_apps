import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  static final Uri _url = Uri.parse(
    'https://jsonplaceholder.typicode.com/users',
  );

  @override
  Future<List<Usuario>> obtener() async {
    final response = await http.get(_url);

    if (response.statusCode != 200) {
      throw Exception('La API respondió con el código ${response.statusCode}.');
    }

    final decodedJson = jsonDecode(response.body);

    if (decodedJson is! List) {
      throw const FormatException('La respuesta no contiene una lista.');
    }

    return decodedJson.map<Usuario>((json) {
      if (json is! Map<String, dynamic>) {
        throw const FormatException(
          'La respuesta contiene un usuario inválido.',
        );
      }

      final id = json['id'];
      final nombre = json['name'];
      final email = json['email'];

      if (id is! int || nombre is! String || email is! String) {
        throw const FormatException('Los datos del usuario son inválidos.');
      }

      return Usuario(id: id, nombre: nombre, email: email);
    }).toList();
  }
}
