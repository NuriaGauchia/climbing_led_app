import 'package:flutter/material.dart';
import '../filters/route_filter.dart';
import '../constants/grades.dart';

class FilterModal extends StatefulWidget {
  final RouteFilter filter;
  final void Function(RouteFilter) onApply;

  const FilterModal({
    super.key,
    required this.filter,
    required this.onApply,
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late TextEditingController nameController;
  late TextEditingController creatorController;
  String? minGrade;
  String? maxGrade;
  String done = 'todos';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.filter.name);
    creatorController = TextEditingController(text: widget.filter.creator);
    minGrade = widget.filter.minGrade;
    maxGrade = widget.filter.maxGrade;
    done = widget.filter.done;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filtrar bloques', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre del bloque'),
            ),
            TextField(
              controller: creatorController,
              decoration: const InputDecoration(labelText: 'Nombre del creador'),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: minGrade,
                    items: kClimbingGrades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (value) => setState(() => minGrade = value),
                    decoration: const InputDecoration(labelText: 'Grado mínimo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: maxGrade,
                    items: kClimbingGrades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (value) => setState(() => maxGrade = value),
                    decoration: const InputDecoration(labelText: 'Grado máximo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: done,
              items: const [
                DropdownMenuItem(value: 'todos', child: Text('Todos')),
                DropdownMenuItem(value: 'hechos', child: Text('Hechos')),
                DropdownMenuItem(value: 'no_hechos', child: Text('No hechos')),
              ],
              onChanged: (value) => setState(() => done = value!),
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onApply(RouteFilter(
                      name: nameController.text,
                      creator: creatorController.text,
                      minGrade: minGrade,
                      maxGrade: maxGrade,
                      done: done,
                    ));
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Aplicar filtros'),
                ),
                TextButton.icon(
                  onPressed: () {
                    widget.onApply(RouteFilter());
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Borrar filtros'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
