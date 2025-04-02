import 'package:flutter/material.dart';

const bool isAdmin = true;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
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
                Navigator.pushNamed(context, '/scan'); // ✅ va a la pantalla
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar muro'),
              onTap: () {
                // Por ahora solo simulado, más adelante implementamos
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función Editar muro (próximamente)')),
                );
              },
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

