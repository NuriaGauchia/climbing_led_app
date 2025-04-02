import 'package:flutter/material.dart';
import '../models/wall_config_model.dart';
import '../services/wall_config_service.dart';

class WallEditorPage extends StatefulWidget {
  const WallEditorPage({super.key});

  @override
  State<WallEditorPage> createState() => _WallEditorPageState();
}

class _WallEditorPageState extends State<WallEditorPage> {
  WallConfig? wallConfig;
  Set<int> activeCells = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWall();
  }

  Future<void> loadWall() async {
    final config = await WallConfigService.loadConfig();
    if (config != null) {
      setState(() {
        wallConfig = config;
        activeCells = config.activeCells.toSet();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleCell(int index) {
    setState(() {
      if (activeCells.contains(index)) {
        activeCells.remove(index);
      } else {
        activeCells.add(index);
      }
    });
  }

  Future<void> saveWall() async {
    if (wallConfig == null) return;

    final updated = WallConfig(
      rows: wallConfig!.rows,
      cols: wallConfig!.cols,
      activeCells: activeCells.toList(),
    );

    await WallConfigService.saveConfig(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Muro actualizado')),
    );
    Navigator.pop(context);
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
        appBar: AppBar(title: const Text('Editar muro')),
        body: const Center(
          child: Text('No hay configuración del muro. Ve a escanear primero.'),
        ),
      );
    }

    final totalCells = wallConfig!.rows * wallConfig!.cols;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar muro')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Haz clic en las celdas para activar o desactivar presas',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: wallConfig!.cols,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final isActive = activeCells.contains(index);
                return GestureDetector(
                  onTap: () => toggleCell(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green : Colors.grey[300],
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
              onPressed: saveWall,
              icon: const Icon(Icons.save),
              label: const Text('Guardar muro'),
            ),
          ),
        ],
      ),
    );
  }
}