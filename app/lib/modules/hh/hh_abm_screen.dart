import 'package:flutter/material.dart';

import 'hh_mock_data.dart';

class HhAbmScreen extends StatelessWidget {
  const HhAbmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABM HH'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Gestion de hermanos',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Altas, bajas y modificaciones del cuadro logico.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _ActionCard(
            title: 'Nuevo',
            subtitle: 'Crear un nuevo hermano y completar sus datos.',
            icon: Icons.person_add,
            onTap: () => _showNuevo(context),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            title: 'Editar',
            subtitle: 'Seleccionar un hermano para modificar.',
            icon: Icons.edit,
            onTap: () => _showEditar(context),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            title: 'Borrar',
            subtitle: 'Seleccion multiple para baja logica.',
            icon: Icons.delete_outline,
            onTap: () => _showBorrar(context),
          ),
        ],
      ),
    );
  }
}

Future<void> _showNuevo(BuildContext context) async {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Alta de HH pendiente de implementar.')),
  );
}

Future<void> _showEditar(BuildContext context) async {
  final selected = await _selectHermano(context, allowMulti: false);
  if (selected == null) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Editar HH ${selected.first} (pendiente).')),
  );
}

Future<void> _showBorrar(BuildContext context) async {
  final selected = await _selectHermano(context, allowMulti: true);
  if (selected == null || selected.isEmpty) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Borrar ${selected.length} HH (pendiente).')),
  );
}

Future<List<String>?> _selectHermano(
  BuildContext context, {
  required bool allowMulti,
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (_) => _HhSelectDialog(allowMulti: allowMulti),
  );
}

class _HhSelectDialog extends StatefulWidget {
  const _HhSelectDialog({required this.allowMulti});

  final bool allowMulti;

  @override
  State<_HhSelectDialog> createState() => _HhSelectDialogState();
}

class _HhSelectDialogState extends State<_HhSelectDialog> {
  final Set<String> _selectedLegajos = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.allowMulti
                      ? 'Seleccion multiple'
                      : 'Seleccionar HH',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 280,
                child: ListView(
                  children: [
                    for (final hermano in HhMockData.hermanos)
                      widget.allowMulti
                          ? CheckboxListTile(
                              value: _selectedLegajos.contains(hermano.legajo),
                              title: Text(
                                '${hermano.apellidos}, ${hermano.nombres}',
                              ),
                              subtitle: Text('Legajo ${hermano.legajo}'),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedLegajos.add(hermano.legajo);
                                  } else {
                                    _selectedLegajos.remove(hermano.legajo);
                                  }
                                });
                              },
                            )
                          : RadioListTile<String>(
                              value: hermano.legajo,
                              groupValue: _selectedLegajos.isEmpty
                                  ? null
                                  : _selectedLegajos.first,
                              title: Text(
                                '${hermano.apellidos}, ${hermano.nombres}',
                              ),
                              subtitle: Text('Legajo ${hermano.legajo}'),
                              onChanged: (value) {
                                setState(() {
                                  _selectedLegajos
                                    ..clear()
                                    ..add(value ?? hermano.legajo);
                                });
                              },
                            ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (_selectedLegajos.isEmpty) {
                        Navigator.of(context).pop(<String>[]);
                        return;
                      }
                      Navigator.of(context).pop(_selectedLegajos.toList());
                    },
                    child: const Text('Continuar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF274C77),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
