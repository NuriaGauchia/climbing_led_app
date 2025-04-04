import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../services/route_storage_service.dart';
import '../filters/route_filter.dart';
import '../widgets/filter_modal.dart';
import '../constants/grades.dart';
import 'view_route_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ClimbingRoute> routes = [];
  List<ClimbingRoute> filteredRoutes = [];
  bool isLoading = true;

  RouteFilter filter = RouteFilter();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadRoutes();
    });
  }

  Future<void> loadRoutes() async {
    setState(() => isLoading = true);
    final loaded = await RouteStorageService.loadRoutes();
    setState(() {
      routes = loaded;
      filteredRoutes = applyFilters(routes, filter, kClimbingGrades);
      isLoading = false;
    });
  }

  void openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterModal(
        filter: filter,
        onApply: (newFilter) {
          setState(() {
            filter = newFilter;
            filteredRoutes = applyFilters(routes, filter, kClimbingGrades);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis bloques'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: openFilterModal,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () => Navigator.pushNamed(context, '/'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ajustes'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredRoutes.isEmpty
              ? const Center(child: Text('No hay bloques que coincidan con los filtros.'))
              : ListView.builder(
                  itemCount: filteredRoutes.length,
                  itemBuilder: (context, index) {
                    final route = filteredRoutes[index];
                    final realIndex = routes.indexOf(route);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewRoutePage(route: route, index: realIndex),
                            ),
                          );
                          if (result == true) {
                            await loadRoutes(); // Recarga si se eliminó el bloque
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(route.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text('Creador: ${route.creator}'),
                                  ],
                                ),
                              ),
                              Chip(
                                label: Text(route.grade),
                                backgroundColor: Colors.grey[200],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/create');
          if (result == true) {
            await loadRoutes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}