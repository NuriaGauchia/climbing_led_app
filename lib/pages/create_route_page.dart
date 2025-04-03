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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  WallConfig? wallConfig;
  bool isLoading = true;

  final Map<int, HoldType> selectedHolds = {}; // nuevo formato
  HoldType selectedType = HoldType.path; // tipo por defecto

  final List<String> grades = [
    '?',
    'V+',
    '6a', '6a+',
    '6b', '6b+',
    '6c', '6c+',
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
      if (selectedHolds.containsKey(index)) {
        selectedHolds.remove(index);
      } else {
        selectedHolds[index] = selectedType;
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
      holds: selectedHolds,
      creator: 'nuria_dev',
    );

    await RouteStorageService.saveRoute(route);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bloque guardado")),
    );

    Navigator.pop(context, true);
  }

  Color getColorForType(HoldType? type) {
    switch (type) {
      case HoldType.start:
        return Colors.red;
      case HoldType.path:
        return Colors.blue;
      case HoldType.finish:
        return Colors.yellow;
      case HoldType.foot:
        return Colors.green;
      default:
        return Colors.grey[300]!;
    }
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
        appBar: AppBar(title: const Text('Crear nuevo bloque')),
        body: const Center(
          child: Text('Primero debes escanear y configurar el muro en Ajustes.'),
        ),
      );
    }

    final totalCells = wallConfig!.rows * wallConfig!.cols;
    final activeCells = wallConfig!.activeCells;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear nuevo bloque')),
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
                    width: 160,
                    child: DropdownButtonFormField<String>(
                      value: gradeController.text.isNotEmpty ? gradeController.text : null,
                      items: grades.map((grade) => DropdownMenuItem(value: grade, child: Text(grade))).toList(),
                      onChanged: (value) => setState(() => gradeController.text = value!),
                      decoration: const InputDecoration(labelText: 'Dificultad'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tipo de presa actual:'),
                Wrap(
                  spacing: 8,
                  children: HoldType.values.map((type) {
                    return ChoiceChip(
                      label: Text(type.name),
                      selected: selectedType == type,
                      selectedColor: getColorForType(type),
                      onSelected: (_) => setState(() => selectedType = type),
                    );
                  }).toList(),
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
                if (!activeCells.contains(index)) return const SizedBox.shrink();
                final type = selectedHolds[index];
                return GestureDetector(
                  onTap: () => toggleHold(index),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getColorForType(type),
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