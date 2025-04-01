import 'package:flutter/material.dart';

class RoutesListPage extends StatelessWidget {
  const RoutesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista temporal de bloques de ejemplo
    final List<Map<String, String>> routes = [
      {'name': 'Bloque 1', 'grade': '6A'},
      {'name': 'Bloque 2', 'grade': '6B+'},
      {'name': 'Bloque 3', 'grade': '7A'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Bloques creados')),
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          return ListTile(
            title: Text(route['name'] ?? ''),
            subtitle: Text('Dificultad: ${route['grade']}'),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // Navegar a la edición del bloque (más adelante)
              Navigator.pushNamed(context, '/edit');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}