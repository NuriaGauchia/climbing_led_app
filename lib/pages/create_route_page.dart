import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../models/wall_config_model.dart';
import '../services/route_storage_service.dart';
import '../services/wall_config_service.dart';

class CreateRoutePage extends StatefulWidget {
  const CreateRoutePage({super.key});

  @override
  State<CreateRoutePage> createState() => _CreateRoutePageState();
}

class _CreateRoutePageState extends State<CreateRoutePage> {
  final Set<int> selectedHolds = {};
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  WallConfig? wallConfig;
  bool isLoading = true;

  final List<String> grades = [
    '?',
    'V+',
    '6a', '6a+',
    '6b', '6b+',
    '6c', '6c/+', '6c+',
    '7a', '7a+',
    '7b', '7b+',
    '7c', '7c+',
    '8a', '8a+',
    '8b', '8b+',
    '8c', '8c+',
    '9a', '9a+',
    '9b', '9b+',
    '9c',
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final config = await WallConfigService.loadConfig();
      setState(() {
        wallConfig = config;
        isLoading = false;
      });
    });
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

    Navigator.pop(context, true); // ✅ Devuelve true para refrescar
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (wallConfig == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Crear nuevo bloque'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text(
            'Primero debes escanear y configurar el muro en Ajustes.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final totalCells = wallConfig!.rows * wallConfig!.cols;
    final activeCells = wallConfig!.activeCells;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear nuevo bloque'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre del bloque'),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 160, // ajusta el ancho según tu diseño
                    child: DropdownButtonFormField<String>(
                      value: gradeController.text.isNotEmpty ? gradeController.text : null,
                      items: grades.map((grade) {
                        return DropdownMenuItem(
                          value: grade,
                          child: Text(grade),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            gradeController.text = value;
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        labelText: 'Dificultad',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Toca las presas activas para seleccionarlas'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: wallConfig!.cols,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final isAvailable = activeCells.contains(index);
                final isSelected = selectedHolds.contains(index);

                if (!isAvailable) {
                  return const SizedBox.shrink();
                }

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
