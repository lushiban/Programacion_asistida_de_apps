import 'package:flutter/material.dart';

import '../domain/usecases/obtener_usuarios_con_vocal.dart';
import 'screens/usuarios_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.obtenerUsuariosConVocal});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Usuarios',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: UsersScreen(obtenerUsuariosConVocal: obtenerUsuariosConVocal),
    );
  }
}
