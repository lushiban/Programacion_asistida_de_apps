import 'package:actividadsem6/data/repositories/supabase_auth_repository.dart';
import 'package:actividadsem6/data/repositories/supabase_perfiles_repository.dart';
import 'package:actividadsem6/data/repositories/supabase_registros_prueba_repository.dart';
import 'package:actividadsem6/domain/usecases/obtener_registros_prueba.dart';
import 'package:actividadsem6/domain/usecases/registrar_usuario.dart';
import 'package:actividadsem6/presentation/pantallas/home_page.dart';
import 'package:actividadsem6/presentation/providers/perfiles_provider.dart';
import 'package:actividadsem6/presentation/providers/registros_prueba_provider.dart';
import 'package:actividadsem6/presentation/providers/sesion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_KEY']!,
  );

  final authRepo = SupabaseAuthRepository();
  final perfilesRepo = SupabasePerfilesRepository();
  final registrarUsuario = RegistrarUsuario(authRepo, perfilesRepo);

  final repository = SupabaseRegistrosPruebaRepository(
    Supabase.instance.client,
  );
  final obtenerRegistros = ObtenerRegistrosPrueba(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SesionProvider>(
          create: (_) => SesionProvider(authRepo, registrarUsuario),
        ),
        ChangeNotifierProvider<PerfilesProvider>(
          create: (_) => PerfilesProvider(perfilesRepo),
        ),
      ],
      child: ChangeNotifierProvider<RegistrosPruebaProvider>(
        create: (_) => RegistrosPruebaProvider(obtenerRegistros)..cargar(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Tabla_prueba', home: HomePage());
  }
}
