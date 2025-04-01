import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../services/route_storage_service.dart';

class CreateRoutePage extends StatefulWidget {
  const CreateRoutePage({super.key});

  @override
  State<CreateRoutePage> createState() => _CreateRoutePageState();
}

class _CreateRoutePageState extends State<CreateRoutePage> {
  final Set<int> selectedHolds = {};
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  void toggleHold(int index) {
    setState(() {
      if (selectedHolds.contains(index)) {
        selectedHolds.remove(index);
      } else {
        selectedHolds.add(index);
      }
    });
  }

  Future<void> saveRoute() async {
    if (nameController.text.isEmpty || gradeController.text.isEmpty || selectedHolds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, rellena todos los campos")),
      );
      return;
    }

    final route = ClimbingRoute(
      name: nameController.text,
      grade: gradeController.text,
      holds: selectedHolds.toList(),
    );

    await RouteStorageService.saveRoute(route);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bloque guardado")),
    );

    Navigator.pop(context); // volver a la lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear nuevo bloque')),
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
                  decoration: const InputDecoration(labelText: 'Dificultad (ej: 6A, 7B+)'),
                ),
                const SizedBox(height: 16),
                const Text('Toca las presas para seleccionarlas'),
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
                      color: isSelected ? Colors.green : Colors.grey[300],
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
              onPressed: saveRoute,
              icon: const Icon(Icons.save),
              label: const Text('Guardar bloque'),
            ),
          ),
        ],
      ),
    );
  }
}