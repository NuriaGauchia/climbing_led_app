import 'package:flutter/material.dart';
import '../constants/app_config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Muro: $wallName", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/scan'),
              child: const Text('Escanear muro'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/editor'),
              child: const Text('Editar muro'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/create'),
              child: const Text('Crear bloque'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: const Text('Ajustes'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/routes'),
              child: const Text('Ver bloques'),
            ),
          ],
        ),
      ),
    );
  }
}