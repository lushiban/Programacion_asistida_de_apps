import 'package:actividadsem6/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepository implements AuthRepository {
  @override
  Future<String> registrar(String correo, String clave) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: correo,
      password: clave,
    );
    final id = response.user?.id;
    if (id == null) {
      throw StateError('Supabase no devolvió el ID del usuario registrado.');
    }
    if (response.session == null) {
      throw StateError(
        'No se inició sesión tras el registro. Confirma el correo y luego '
        'ingresa; no vuelvas a crear la misma cuenta. El perfil aún no se creó.',
      );
    }
    return id;
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: correo,
      password: clave,
    );
  }

  @override
  Future<void> salir() => Supabase.instance.client.auth.signOut();

  @override
  String? obtenerIdActual() => Supabase.instance.client.auth.currentUser?.id;
}
