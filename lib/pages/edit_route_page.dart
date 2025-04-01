import 'package:flutter/material.dart';

class EditRoutePage extends StatelessWidget {
  const EditRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar bloque')),
      body: const Center(
        child: Text('Aquí podrás editar el bloque seleccionado'),
      ),
    );
  }
}