import 'package:flutter/material.dart';

class WallEditorPage extends StatelessWidget {
  const WallEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editor del muro')),
      body: const Center(child: Text('Aquí podrás visualizar y editar el muro')),
    );
  }
}