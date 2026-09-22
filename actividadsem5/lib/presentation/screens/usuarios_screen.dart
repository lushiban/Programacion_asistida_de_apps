import 'package:flutter/material.dart';

import '../../domain/entities/usuario.dart';
import '../../domain/usecases/obtener_usuarios_con_vocal.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key, required this.obtenerUsuariosConVocal});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Usuario> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = await widget.obtenerUsuariosConVocal.ejecutar();

      if (!mounted) return;
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No se pudieron cargar los usuarios.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 56),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else if (_users.isEmpty) {
      content = const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No hay usuarios cuyo nombre empiece con una vocal.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: _loadUsers,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  child: Text(user.nombre[0].toUpperCase()),
                ),
                title: Text(
                  user.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Correo: ${user.email}'),
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios con nombre en vocal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(child: content),
    );
  }
}
