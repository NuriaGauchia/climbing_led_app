import 'package:flutter/material.dart';
import '../models/route_model.dart';
import '../models/wall_config_model.dart';
import '../services/route_storage_service.dart';
import '../services/wall_config_service.dart';

class EditRoutePage extends StatefulWidget {
  const EditRoutePage({super.key});

  @override
  State<EditRoutePage> createState() => _EditRoutePageState();
}

class _EditRoutePageState extends State<EditRoutePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  Map<int, HoldType> selectedHolds = {}; // tipo de presas
  int routeIndex = -1;
  WallConfig? wallConfig;
  bool isLoading = true;
  HoldType selectedType = HoldType.path;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final ClimbingRoute route = args['route'];
    routeIndex = args['index'];

    nameController.text = route.name;
    gradeController.text = route.grade;
    selectedHolds = Map.from(route.holds);

    WallConfigService.loadConfig().then((config) {
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

  Future<void> saveEditedRoute() async {
    if (nameController.text.isEmpty || gradeController.text.isEmpty) return;

    final edited = ClimbingRoute(
      name: nameController.text,
      grade: gradeController.text,
      holds: selectedHolds,
      creator: 'nuria_dev', // se conserva el creador original si lo deseas
    );

    await RouteStorageService.updateRouteAtIndex(routeIndex, edited);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bloque actualizado")),
    );

    Navigator.pop(context);
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (wallConfig == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar bloque')),
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
      appBar: AppBar(title: const Text('Editar bloque')),
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
                TextField(
                  controller: gradeController,
                  decoration: const InputDecoration(labelText: 'Dificultad'),
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
                const Text('Selecciona las presas para este bloque'),
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