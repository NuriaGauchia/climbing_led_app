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
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    // Enlazar a edición más adelante
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