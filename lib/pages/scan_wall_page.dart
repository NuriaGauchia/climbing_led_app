import 'package:flutter/material.dart';

class ScanWallPage extends StatelessWidget {
  const ScanWallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear muro')),
      body: const Center(child: Text('Aquí irá el escaneo del muro')),
    );
  }
}