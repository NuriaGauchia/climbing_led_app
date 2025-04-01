import 'package:flutter/material.dart';

class CreateRoutePage extends StatelessWidget {
  const CreateRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear bloque')),
      body: const Center(child: Text('Aquí podrás crear nuevos bloques de escalada')),
    );
  }
}
