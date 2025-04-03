import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/route_model.dart';
import '../models/wall_config_model.dart';
import '../services/wall_config_service.dart';
import '../services/route_storage_service.dart';

class ViewRoutePage extends StatefulWidget {
  final ClimbingRoute route;
  final int index;

  const ViewRoutePage({super.key, required this.route, required this.index});

  @override
  State<ViewRoutePage> createState() => _ViewRoutePageState();
}

class _ViewRoutePageState extends State<ViewRoutePage> {
  WallConfig? wallConfig;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWall();
  }

  Future<void> loadWall() async {
    final config = await WallConfigService.loadConfig();
    setState(() {
      wallConfig = config;
      isLoading = false;
    });
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

  Map<String, dynamic> generateLedJson(ClimbingRoute route) {
    final leds = route.holds.entries.map((entry) {
      final index = entry.key;
      final type = entry.value;

      final color = switch (type) {
        HoldType.start => "red",
        HoldType.path => "blue",
        HoldType.finish => "yellow",
        HoldType.foot => "green",
      };

      return {
        "id": index,
        "color": color,
      };
    }).toList();

    return {
      "leds_on": leds,
    };
  }

  Future<void> deleteRoute() async {
    await RouteStorageService.deleteRouteAtIndex(widget.index);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bloque eliminado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (wallConfig == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ver bloque')),
        body: const Center(
          child: Text('Primero debes escanear y configurar el muro.'),
        ),
      );
    }

    final totalCells = wallConfig!.rows * wallConfig!.cols;
    final activeCells = wallConfig!.activeCells;
    final holds = widget.route.holds;

    return Scaffold(
      appBar: AppBar(title: const Text('Ver bloque')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${widget.route.name}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 4),
                Text('Grado: ${widget.route.grade}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final json = generateLedJson(widget.route);
                      debugPrint("Simulando envío a muro:");
                      debugPrint(jsonEncode(json));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comando JSON generado (ver consola)')),
                      );
                    },
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Simular envío al muro'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: wallConfig!.cols,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                if (!activeCells.contains(index)) return const SizedBox.shrink();
                final type = holds[index];
                final color = getColorForType(type);

                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('${index + 1}')),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/edit',
                    arguments: {
                      'index': widget.index,
                      'route': widget.route,
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: deleteRoute,
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}