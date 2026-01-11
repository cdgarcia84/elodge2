import 'package:flutter/material.dart';

import 'hh_mock_data.dart';
import 'hh_model.dart';

class HhListScreen extends StatefulWidget {
  const HhListScreen({super.key});

  @override
  State<HhListScreen> createState() => _HhListScreenState();
}

class _HhListScreenState extends State<HhListScreen> {
  final TextEditingController _searchController = TextEditingController();
  _GradeFilter _selectedFilter = _GradeFilter.todos;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String query = _searchController.text.trim().toLowerCase();
    final List<Hermano> hermanos = HhMockData.hermanos.where((hermano) {
      if (_selectedFilter != _GradeFilter.todos &&
          hermano.grado != _selectedFilter.gradoValue) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final haystack = [
        hermano.apellidos,
        hermano.nombres,
        hermano.legajo,
        hermano.cargo,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuadro logico'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: hermanos.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hermanos del taller',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Listado general del cuadro logico.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar por nombre, legajo o cargo',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _GradeFilter.values.map((filter) {
                    final selected = _selectedFilter == filter;
                    return ChoiceChip(
                      label: Text(filter.label),
                      selected: selected,
                      onSelected: (_) => setState(() {
                        _selectedFilter = filter;
                      }),
                      selectedColor: const Color(0xFF274C77),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: Colors.white,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
              ],
            );
          }

          final hermano = hermanos[index - 1];

          return Card(
            child: ListTile(
              title: Text('${hermano.apellidos}, ${hermano.nombres}'),
              subtitle: Text(
                'Legajo ${hermano.legajo} · Grado ${hermano.grado} · ${hermano.cargo}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showDetail(context, hermano);
              },
            ),
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, Hermano hermano) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${hermano.apellidos}, ${hermano.nombres}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text('Legajo: ${hermano.legajo}'),
              Text('Grado: ${hermano.grado}'),
              Text('Cargo: ${hermano.cargo}'),
              Text('Afiliacion: ${hermano.afiliacion}'),
              Text('Domicilio: ${hermano.domicilio}'),
              Text('Localidad: ${hermano.localidad}'),
              Text('Telefonos: ${hermano.telefonos}'),
              Text('Email: ${hermano.email}'),
            ],
          ),
        );
      },
    );
  }
}

enum _GradeFilter {
  todos('Todos', null),
  maestros('Maestros', '3'),
  companeros('Companeros', '2'),
  aprendices('Aprendices', '1');

  const _GradeFilter(this.label, this.gradoValue);

  final String label;
  final String? gradoValue;
}
