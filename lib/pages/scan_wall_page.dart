import 'package:flutter/material.dart';

class ScanWallPage extends StatefulWidget {
  const ScanWallPage({super.key});

  @override
  State<ScanWallPage> createState() => _ScanWallPageState();
}

class _ScanWallPageState extends State<ScanWallPage> {
  final TextEditingController rowsController = TextEditingController();
  final TextEditingController colsController = TextEditingController();

  int numRows = 0;
  int numCols = 0;
  Set<int> activeCells = {};

  void generateGrid() {
    final rows = int.tryParse(rowsController.text) ?? 0;
    final cols = int.tryParse(colsController.text) ?? 0;

    if (rows > 0 && cols > 0) {
      setState(() {
        numRows = rows;
        numCols = cols;
        activeCells.clear();
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

  void saveWallConfig() {
    // Aquí puedes guardar en SharedPreferences o Firebase
    print('Guardando muro: $numRows x $numCols');
    print('Presas con LED: $activeCells');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Muro guardado')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final totalCells = numRows * numCols;

    return Scaffold(
      appBar: AppBar(title: const Text('Escanear muro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Introduce dimensiones del muro', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: rowsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Filas'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: colsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Columnas'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: generateGrid,
                  child: const Text('Generar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (totalCells > 0)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numCols,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
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
            const SizedBox(height: 16),
            if (totalCells > 0)
              ElevatedButton.icon(
                onPressed: saveWallConfig,
                icon: const Icon(Icons.save),
                label: const Text('Guardar configuración'),
              ),
          ],
        ),
      ),
    );
  }
}