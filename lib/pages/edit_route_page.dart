import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../services/route_storage_service.dart';

class EditRoutePage extends StatefulWidget {
  const EditRoutePage({super.key});

  @override
  State<EditRoutePage> createState() => _EditRoutePageState();
}

class _EditRoutePageState extends State<EditRoutePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();
  Set<int> selectedHolds = {};
  int routeIndex = -1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final ClimbingRoute route = args['route'];
    routeIndex = args['index'];

    nameController.text = route.name;
    gradeController.text = route.grade;
    selectedHolds = route.holds.toSet();
  }

  void toggleHold(int index) {
    setState(() {
      if (selectedHolds.contains(index)) {
        selectedHolds.remove(index);
      } else {
        selectedHolds.add(index);
      }
    });
  }

  Future<void> saveEditedRoute() async {
    if (nameController.text.isEmpty || gradeController.text.isEmpty) return;

    final edited = ClimbingRoute(
      name: nameController.text,
      grade: gradeController.text,
      holds: selectedHolds.toList(),
    );

    await RouteStorageService.updateRouteAtIndex(routeIndex, edited);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bloque actualizado")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar bloque')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre del bloque'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(labelText: 'Dificultad'),
                ),
                const SizedBox(height: 16),
                const Text('Selecciona las presas para este bloque'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 25,
              itemBuilder: (context, index) {
                final isSelected = selectedHolds.contains(index);
                return GestureDetector(
                  onTap: () => toggleHold(index),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.orange : Colors.grey[300],
                      border: Border.all(color: Colors.black),
                    ),
                    child: Center(child: Text('${index + 1}')),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: saveEditedRoute,
              icon: const Icon(Icons.save),
              label: const Text('Guardar cambios'),
            ),
          ),
        ],
      ),
    );
  }
}