import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/route_model.dart';
import '../models/wall_config_model.dart';
import '../services/wall_config_service.dart';

class ViewRoutePage extends StatefulWidget {
  final ClimbingRoute route;

  const ViewRoutePage({super.key, required this.route});

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
                ElevatedButton.icon(
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
        ],
      ),
    );
  }
}
