import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../services/route_storage_service.dart';

class RoutesListPage extends StatefulWidget {
  const RoutesListPage({super.key});

  @override
  State<RoutesListPage> createState() => _RoutesListPageState();
}

class _RoutesListPageState extends State<RoutesListPage> {
  List<ClimbingRoute> routes = [];

  @override
  void initState() {
    super.initState();
    loadRoutes();
  }

  Future<void> loadRoutes() async {
    final loaded = await RouteStorageService.loadRoutes();
    setState(() {
      routes = loaded;
    });
  }

  Future<void> confirmDelete(int index) async {
    final route = routes[index];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar bloque?'),
        content: Text('¿Seguro que quieres eliminar "${route.name}"?'),
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
      await RouteStorageService.deleteRouteAtIndex(index);
      await loadRoutes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloques creados')),
      body: routes.isEmpty
          ? const Center(child: Text('No hay bloques aún.'))
          : ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final route = routes[index];
                return ListTile(
                  title: Text(route.name),
                  subtitle: Text('Dificultad: ${route.grade}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit',
                            arguments: {'index': index, 'route': route},
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => confirmDelete(index),
                      ),
                    ],
                  ),
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