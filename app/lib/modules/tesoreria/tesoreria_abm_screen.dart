import 'package:flutter/material.dart';

import '../../core/session.dart';
import 'tesoreria_mock_data.dart';

class TesoreriaAbmScreen extends StatelessWidget {
  const TesoreriaAbmScreen({super.key, required this.session});

  final UserSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABM Tesoreria'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Gestion de tesoreria',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cargas y ajustes sobre movimientos personales y generales.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _ActionCard(
            title: 'Nuevo',
            subtitle: 'Registrar un nuevo movimiento.',
            icon: Icons.add_circle_outline,
            onTap: () => _handleAction(context, _AbmAction.nuevo),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            title: 'Editar',
            subtitle: 'Seleccionar un movimiento para modificar.',
            icon: Icons.edit,
            onTap: () => _handleAction(context, _AbmAction.editar),
          ),
          const SizedBox(height: 12),
          _ActionCard(
            title: 'Borrar',
            subtitle: 'Seleccion multiple para eliminar.',
            icon: Icons.delete_outline,
            onTap: () => _handleAction(context, _AbmAction.borrar),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, _AbmAction action) async {
    final tipo = await _selectTipo(context);
    if (tipo == null) {
      return;
    }

    switch (action) {
      case _AbmAction.nuevo:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nuevo ${tipo.label} (pendiente).')),
        );
        break;
      case _AbmAction.editar:
        await _selectMovimiento(context, tipo, allowMulti: false);
        break;
      case _AbmAction.borrar:
        await _selectMovimiento(context, tipo, allowMulti: true);
        break;
    }
  }

  Future<_TipoTesoreria?> _selectTipo(BuildContext context) {
    return showDialog<_TipoTesoreria>(
      context: context,
      builder: (_) => const _TipoDialog(),
    );
  }

  Future<void> _selectMovimiento(
    BuildContext context,
    _TipoTesoreria tipo, {
    required bool allowMulti,
  }) async {
    final items = tipo == _TipoTesoreria.personal
        ? (TesoreriaMockData.personalPorLegajo[session.legajo] ?? [])
            .map((mov) => '${mov.concepto} · ${_fmtDate(mov.fecha)}')
            .toList()
        : TesoreriaMockData.general
            .map((mov) => '${mov.concepto} · ${_fmtDate(mov.fecha)}')
            .toList();

    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sin movimientos ${tipo.label}.')),
      );
      return;
    }

    final selected = await showDialog<List<String>>(
      context: context,
      builder: (_) => _MovimientosDialog(
        items: items,
        allowMulti: allowMulti,
        title: '${allowMulti ? 'Borrar' : 'Editar'} ${tipo.label}',
      ),
    );

    if (selected == null || selected.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${allowMulti ? 'Seleccionados' : 'Seleccionado'} ${selected.length}.',
        ),
      ),
    );
  }
}

enum _AbmAction { nuevo, editar, borrar }

enum _TipoTesoreria {
  personal,
  general;

  String get label => this == _TipoTesoreria.personal ? 'personal' : 'general';
}

class _TipoDialog extends StatefulWidget {
  const _TipoDialog();

  @override
  State<_TipoDialog> createState() => _TipoDialogState();
}

class _TipoDialogState extends State<_TipoDialog> {
  _TipoTesoreria _selected = _TipoTesoreria.personal;

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
                  'Seleccionar tipo',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              RadioListTile<_TipoTesoreria>(
                value: _TipoTesoreria.personal,
                groupValue: _selected,
                title: const Text('Personal'),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selected = value);
                  }
                },
              ),
              RadioListTile<_TipoTesoreria>(
                value: _TipoTesoreria.general,
                groupValue: _selected,
                title: const Text('General'),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selected = value);
                  }
                },
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
                    onPressed: () => Navigator.of(context).pop(_selected),
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

class _MovimientosDialog extends StatefulWidget {
  const _MovimientosDialog({
    required this.items,
    required this.allowMulti,
    required this.title,
  });

  final List<String> items;
  final bool allowMulti;
  final String title;

  @override
  State<_MovimientosDialog> createState() => _MovimientosDialogState();
}

class _MovimientosDialogState extends State<_MovimientosDialog> {
  final Set<int> _selected = {};

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
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 260,
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final label = widget.items[index];
                    if (widget.allowMulti) {
                      return CheckboxListTile(
                        value: _selected.contains(index),
                        title: Text(label),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selected.add(index);
                            } else {
                              _selected.remove(index);
                            }
                          });
                        },
                      );
                    }
                    return RadioListTile<int>(
                      value: index,
                      groupValue: _selected.isEmpty ? null : _selected.first,
                      title: Text(label),
                      onChanged: (value) {
                        setState(() {
                          _selected
                            ..clear()
                            ..add(value ?? index);
                        });
                      },
                    );
                  },
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
                      final selected = _selected.isEmpty
                          ? <String>[]
                          : _selected.map((i) => widget.items[i]).toList();
                      Navigator.of(context).pop(selected);
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

String _fmtDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
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
