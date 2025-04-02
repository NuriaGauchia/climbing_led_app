import 'package:flutter/material.dart';
import '../constants/app_config.dart';
import '../services/wall_config_service.dart';
import '../services/route_storage_service.dart';

const bool isAdmin = true;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> resetWallAndRoutes(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Resetear muro?'),
        content: const Text('Esto eliminará el muro y todos los bloques guardados. ¿Seguro que quieres continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await WallConfigService.clearConfig();
      await RouteStorageService.clearAllRoutes();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Muro y bloques eliminados')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        leading: const BackButton(), // ← en vez del drawer
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.wallpaper),
            title: Text('Muro activo: $wallName'),
          ),
          const Divider(),

          const ListTile(
            title: Text('Preferencias'),
            subtitle: Text('Aquí podrías poner configuración general'),
          ),
          const Divider(),

          if (isAdmin) ...[
            const ListTile(
              title: Text('Administrador'),
              subtitle: Text('Opciones solo visibles para administradores'),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Escanear muro'),
              onTap: () {
                Navigator.pushNamed(context, '/scan');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar muro'),
              onTap: () {
                Navigator.pushNamed(context, '/editor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Resetear muro y bloques'),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () => resetWallAndRoutes(context),
            ),
            const Divider(),
          ],

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Acerca de'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Climbing LED App',
                applicationVersion: 'v1.0',
              );
            },
          ),
        ],
      ),
    );
  }
}
