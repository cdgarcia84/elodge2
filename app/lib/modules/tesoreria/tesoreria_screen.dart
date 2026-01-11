import 'package:flutter/material.dart';

import '../../core/session.dart';
import '../hh/hh_mock_data.dart';
import 'tesoreria_mock_data.dart';
import 'tesoreria_models.dart';

class TesoreriaScreen extends StatelessWidget {
  const TesoreriaScreen({
    super.key,
    required this.session,
    this.readOnly = false,
  });

  final UserSession session;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final List<TesoreriaPersonalMovimiento> movimientosPersonal =
        TesoreriaMockData.personalPorLegajo[session.legajo] ?? [];
    final canEdit =
        !readOnly && (session.rolGestion == 'VM' || session.rolGestion == 'Tesorero');
    final tabs = _buildTabs(
      personalMovs: movimientosPersonal,
      canEdit: canEdit,
      currentLegajo: session.legajo,
    );

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tesoreria'),
          bottom: tabs.length > 1
              ? TabBar(tabs: tabs.map((t) => t.tab).toList())
              : null,
        ),
        body: tabs.length == 1
            ? tabs.first.view
            : TabBarView(children: tabs.map((t) => t.view).toList()),
      ),
    );
  }
}

class _TesoreriaTab {
  const _TesoreriaTab({required this.tab, required this.view});

  final Tab tab;
  final Widget view;
}

List<_TesoreriaTab> _buildTabs({
  required List<TesoreriaPersonalMovimiento> personalMovs,
  required bool canEdit,
  required String? currentLegajo,
}) {
  final tabs = <_TesoreriaTab>[];
  tabs.add(
    _TesoreriaTab(
      tab: const Tab(text: 'Personal'),
      view: _PersonalTab(
        movimientos: personalMovs,
        canEdit: canEdit,
        currentLegajo: currentLegajo,
      ),
    ),
  );
  tabs.add(
    _TesoreriaTab(
      tab: const Tab(text: 'General'),
      view: _GeneralTab(
        movimientos: TesoreriaMockData.general,
        canEdit: canEdit,
      ),
    ),
  );

  return tabs;
}

class _PersonalTab extends StatefulWidget {
  const _PersonalTab({
    required this.movimientos,
    required this.canEdit,
    required this.currentLegajo,
  });

  final List<TesoreriaPersonalMovimiento> movimientos;
  final bool canEdit;
  final String? currentLegajo;

  @override
  State<_PersonalTab> createState() => _PersonalTabState();
}

class _PersonalTabState extends State<_PersonalTab> {
  late List<TesoreriaPersonalMovimiento> _items;
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _items = List<TesoreriaPersonalMovimiento>.from(widget.movimientos)
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.isEmpty ? 4 : _items.length + 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _HeaderCard(
            title: 'Resumen personal',
            subtitle: 'Movimientos y deuda del hermano.',
          );
        }
        if (index == 1) {
          return _SectionHeader(
            title: 'Tesoreria personal',
            canEdit: widget.canEdit,
            selectedCount: _selected.length,
            onAdd: widget.canEdit ? _showAddPersonalDialog : null,
            onDeleteSelected:
                widget.canEdit && _selected.isNotEmpty ? _deleteSelected : null,
          );
        }
        if (index == 2) {
          return const _PersonalHeader();
        }
        if (_items.isEmpty) {
          return const _RowCard(
            child: Text('Sin movimientos personales.'),
          );
        }

        final itemIndex = index - 3;
        final item = _items[itemIndex];
        final isSelected = _selected.contains(itemIndex);
        final montoColor = item.monto < 0 ? Colors.red : Colors.green;

        return _RowCard(
          selected: isSelected,
          onTap: widget.canEdit && _selected.isNotEmpty
              ? () => _toggleSelection(itemIndex)
              : null,
          onLongPress: widget.canEdit
              ? () => _toggleSelection(itemIndex)
              : null,
          child: Row(
            children: [
              if (widget.canEdit)
                SizedBox(
                  width: 32,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(itemIndex),
                  ),
                ),
              Expanded(flex: 2, child: Text(_fmtDate(item.fecha))),
              Expanded(flex: 5, child: Text(item.concepto)),
              Expanded(
                flex: 3,
                child: Text(
                  _fmtMoney(item.monto),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: montoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.canEdit)
                SizedBox(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Editar',
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _showEditPersonalDialog(itemIndex),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () => _deleteSingle(itemIndex),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  void _deleteSelected() {
    setState(() {
      final indices = _selected.toList()..sort((a, b) => b.compareTo(a));
      for (final index in indices) {
        _items.removeAt(index);
      }
      _selected.clear();
    });
  }

  void _deleteSingle(int index) {
    setState(() {
      _items.removeAt(index);
      _selected.remove(index);
    });
  }

  Future<void> _showAddPersonalDialog() async {
    final result = await _PersonalMovimientoDialog.show(
      context,
      initialDate: DateTime.now(),
      allowMultiSelect: true,
      currentLegajo: widget.currentLegajo,
    );
    if (result == null) {
      return;
    }

    if (result.appliedToCurrent) {
      setState(() {
        _items.add(
          TesoreriaPersonalMovimiento(
            fecha: result.fecha,
            concepto: result.concepto,
            monto: result.monto,
          ),
        );
        _items.sort((a, b) => a.fecha.compareTo(b.fecha));
      });
    }

    _showMessage(
      context,
      'Entrada aplicada a ${result.appliedCount} HH.',
    );
  }

  Future<void> _showEditPersonalDialog(int index) async {
    final item = _items[index];
    final result = await _PersonalMovimientoDialog.show(
      context,
      initialDate: item.fecha,
      initialConcepto: item.concepto,
      initialMonto: item.monto,
      allowMultiSelect: false,
      currentLegajo: widget.currentLegajo,
    );
    if (result == null) {
      return;
    }
    setState(() {
      _items[index] = TesoreriaPersonalMovimiento(
        fecha: result.fecha,
        concepto: result.concepto,
        monto: result.monto,
      );
    });
  }
}

class _GeneralTab extends StatefulWidget {
  const _GeneralTab({required this.movimientos, required this.canEdit});

  final List<TesoreriaGeneralMovimiento> movimientos;
  final bool canEdit;

  @override
  State<_GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<_GeneralTab> {
  late List<TesoreriaGeneralMovimiento> _items;
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _items = List<TesoreriaGeneralMovimiento>.from(widget.movimientos);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length + 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _HeaderCard(
            title: 'Resumen general',
            subtitle: 'Ingresos y egresos del taller.',
          );
        }
        if (index == 1) {
          return _SectionHeader(
            title: 'Tesoreria general',
            canEdit: widget.canEdit,
            selectedCount: _selected.length,
            onAdd: widget.canEdit ? _showAddGeneralDialog : null,
            onDeleteSelected:
                widget.canEdit && _selected.isNotEmpty ? _deleteSelected : null,
          );
        }
        if (index == 2) {
          return const _GeneralHeader();
        }

        final itemIndex = index - 3;
        final movimiento = _items[itemIndex];
        final isSelected = _selected.contains(itemIndex);

        return _RowCard(
          selected: isSelected,
          onTap: widget.canEdit && _selected.isNotEmpty
              ? () => _toggleSelection(itemIndex)
              : null,
          onLongPress: widget.canEdit
              ? () => _toggleSelection(itemIndex)
              : null,
          child: Row(
            children: [
              if (widget.canEdit)
                SizedBox(
                  width: 32,
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(itemIndex),
                  ),
                ),
              Expanded(flex: 2, child: Text(_fmtDate(movimiento.fecha))),
              Expanded(flex: 3, child: Text(movimiento.concepto)),
              Expanded(
                flex: 2,
                child: Text(
                  movimiento.montoEfectivo == null
                      ? '-'
                      : _fmtMoney(movimiento.montoEfectivo!),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  movimiento.montoVirtual == null
                      ? '-'
                      : _fmtMoney(movimiento.montoVirtual!),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(flex: 4, child: Text(movimiento.detalle)),
              if (widget.canEdit)
                SizedBox(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Editar',
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _showEditGeneralDialog(itemIndex),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () => _deleteSingle(itemIndex),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selected.contains(index)) {
        _selected.remove(index);
      } else {
        _selected.add(index);
      }
    });
  }

  void _deleteSelected() {
    setState(() {
      final indices = _selected.toList()..sort((a, b) => b.compareTo(a));
      for (final index in indices) {
        _items.removeAt(index);
      }
      _selected.clear();
    });
  }

  void _deleteSingle(int index) {
    setState(() {
      _items.removeAt(index);
      _selected.remove(index);
    });
  }

  Future<void> _showAddGeneralDialog() async {
    final result = await _GeneralMovimientoDialog.show(
      context,
      initialDate: DateTime.now(),
    );
    if (result == null) {
      return;
    }
    setState(() {
      _items.add(
        TesoreriaGeneralMovimiento(
          fecha: result.fecha,
          concepto: result.concepto,
          montoEfectivo: result.montoEfectivo,
          montoVirtual: result.montoVirtual,
          detalle: result.detalle,
        ),
      );
    });
  }

  Future<void> _showEditGeneralDialog(int index) async {
    final item = _items[index];
    final result = await _GeneralMovimientoDialog.show(
      context,
      initialDate: item.fecha,
      initialConcepto: item.concepto,
      initialMontoEfectivo: item.montoEfectivo,
      initialMontoVirtual: item.montoVirtual,
      initialDetalle: item.detalle,
    );
    if (result == null) {
      return;
    }
    setState(() {
      _items[index] = TesoreriaGeneralMovimiento(
        fecha: result.fecha,
        concepto: result.concepto,
        montoEfectivo: result.montoEfectivo,
        montoVirtual: result.montoVirtual,
        detalle: result.detalle,
      );
    });
  }
}

class _PersonalHeader extends StatelessWidget {
  const _PersonalHeader();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return _RowCard(
      tone: const Color(0xFFF2F5FA),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Fecha', style: style)),
          Expanded(flex: 5, child: Text('Concepto', style: style)),
          Expanded(
            flex: 3,
            child: Text('Monto', style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _GeneralHeader extends StatelessWidget {
  const _GeneralHeader();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return _RowCard(
      tone: const Color(0xFFF2F5FA),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Fecha', style: style)),
          Expanded(flex: 3, child: Text('Concepto', style: style)),
          Expanded(
            flex: 2,
            child:
                Text('Efectivo', style: style, textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 2,
            child: Text('Virtual', style: style, textAlign: TextAlign.right),
          ),
          Expanded(flex: 4, child: Text('Detalle', style: style)),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  const _RowCard({
    required this.child,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.tone,
  });

  final Widget child;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final baseColor = tone ?? Colors.white;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selected
            ? Theme.of(context).colorScheme.primaryContainer
            : baseColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: child,
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.canEdit,
    required this.selectedCount,
    required this.onAdd,
    required this.onDeleteSelected,
  });

  final String title;
  final bool canEdit;
  final int selectedCount;
  final VoidCallback? onAdd;
  final VoidCallback? onDeleteSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (canEdit)
              Row(
                children: [
                  if (selectedCount > 0 && onDeleteSelected != null)
                    IconButton(
                      tooltip: 'Eliminar seleccion',
                      onPressed: onDeleteSelected,
                      icon: const Icon(Icons.delete_outline),
                    ),
                  if (onAdd != null)
                    FilledButton.icon(
                      onPressed: onAdd,
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                ],
              ),
          ],
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

String _fmtMoney(int amount) {
  final sign = amount < 0 ? '-' : '';
  final absolute = amount.abs().toString();
  return '$sign\$$absolute';
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class _PersonalMovimientoResult {
  const _PersonalMovimientoResult({
    required this.fecha,
    required this.concepto,
    required this.monto,
    required this.appliedCount,
    required this.appliedToCurrent,
  });

  final DateTime fecha;
  final String concepto;
  final int monto;
  final int appliedCount;
  final bool appliedToCurrent;
}

class _PersonalMovimientoDialog extends StatefulWidget {
  const _PersonalMovimientoDialog({
    required this.initialDate,
    this.initialConcepto,
    this.initialMonto,
    required this.allowMultiSelect,
    required this.currentLegajo,
  });

  final DateTime initialDate;
  final String? initialConcepto;
  final int? initialMonto;
  final bool allowMultiSelect;
  final String? currentLegajo;

  static Future<_PersonalMovimientoResult?> show(
    BuildContext context, {
    required DateTime initialDate,
    String? initialConcepto,
    int? initialMonto,
    required bool allowMultiSelect,
    required String? currentLegajo,
  }) {
    return showDialog<_PersonalMovimientoResult>(
      context: context,
      useRootNavigator: true,
      builder: (_) => _PersonalMovimientoDialog(
        initialDate: initialDate,
        initialConcepto: initialConcepto,
        initialMonto: initialMonto,
        allowMultiSelect: allowMultiSelect,
        currentLegajo: currentLegajo,
      ),
    );
  }

  @override
  State<_PersonalMovimientoDialog> createState() =>
      _PersonalMovimientoDialogState();
}

class _PersonalMovimientoDialogState extends State<_PersonalMovimientoDialog> {
  late DateTime _fecha;
  final TextEditingController _conceptoController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final Map<String, bool> _selectedLegajos = {};

  @override
  void initState() {
    super.initState();
    _fecha = widget.initialDate;
    _conceptoController.text = widget.initialConcepto ?? '';
    _montoController.text =
        widget.initialMonto == null ? '' : widget.initialMonto.toString();
    for (final hermano in HhMockData.hermanos) {
      _selectedLegajos[hermano.legajo] =
          hermano.legajo == widget.currentLegajo;
    }
  }

  @override
  void dispose() {
    _conceptoController.dispose();
    _montoController.dispose();
    super.dispose();
  }

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
                  'Movimiento personal',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _conceptoController,
                decoration: const InputDecoration(labelText: 'Concepto'),
              ),
              TextField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Fecha:'),
                  const SizedBox(width: 8),
                  Text(_fmtDate(_fecha)),
                  const Spacer(),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Cambiar'),
                  ),
                ],
              ),
              if (widget.allowMultiSelect) ...[
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Aplicar a:'),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 180,
                  child: ListView(
                    children: [
                      for (final hermano in HhMockData.hermanos)
                        CheckboxListTile(
                          value: _selectedLegajos[hermano.legajo] ?? false,
                          title:
                              Text('${hermano.apellidos}, ${hermano.nombres}'),
                          subtitle: Text('Legajo ${hermano.legajo}'),
                          onChanged: (value) {
                            setState(() {
                              _selectedLegajos[hermano.legajo] = value ?? false;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ],
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
                    onPressed: _submit,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (!mounted) {
      return;
    }
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  void _submit() {
    final concepto = _conceptoController.text.trim();
    final monto = int.tryParse(_montoController.text.trim());
    if (concepto.isEmpty || monto == null) {
      _showMessage(context, 'Completa concepto y monto valido.');
      return;
    }

    final selected = _selectedLegajos.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    final appliedCount =
        widget.allowMultiSelect ? (selected.isEmpty ? 1 : selected.length) : 1;
    final appliedToCurrent = widget.allowMultiSelect
        ? (selected.isEmpty || selected.contains(widget.currentLegajo))
        : true;

    if (widget.allowMultiSelect &&
        selected.isNotEmpty &&
        !selected.contains(widget.currentLegajo)) {
      _showMessage(
        context,
        'Movimiento aplicado a otros HH (no afecta tu cuenta).',
      );
    }

    Navigator.of(context).pop(
      _PersonalMovimientoResult(
        fecha: _fecha,
        concepto: concepto,
        monto: monto,
        appliedCount: appliedCount,
        appliedToCurrent: appliedToCurrent,
      ),
    );
  }
}

class _GeneralMovimientoResult {
  const _GeneralMovimientoResult({
    required this.fecha,
    required this.concepto,
    required this.montoEfectivo,
    required this.montoVirtual,
    required this.detalle,
  });

  final DateTime fecha;
  final String concepto;
  final int? montoEfectivo;
  final int? montoVirtual;
  final String detalle;
}

class _GeneralMovimientoDialog extends StatefulWidget {
  const _GeneralMovimientoDialog({
    required this.initialDate,
    this.initialConcepto,
    this.initialMontoEfectivo,
    this.initialMontoVirtual,
    this.initialDetalle,
  });

  final DateTime initialDate;
  final String? initialConcepto;
  final int? initialMontoEfectivo;
  final int? initialMontoVirtual;
  final String? initialDetalle;

  static Future<_GeneralMovimientoResult?> show(
    BuildContext context, {
    required DateTime initialDate,
    String? initialConcepto,
    int? initialMontoEfectivo,
    int? initialMontoVirtual,
    String? initialDetalle,
  }) {
    return showDialog<_GeneralMovimientoResult>(
      context: context,
      useRootNavigator: true,
      builder: (_) => _GeneralMovimientoDialog(
        initialDate: initialDate,
        initialConcepto: initialConcepto,
        initialMontoEfectivo: initialMontoEfectivo,
        initialMontoVirtual: initialMontoVirtual,
        initialDetalle: initialDetalle,
      ),
    );
  }

  @override
  State<_GeneralMovimientoDialog> createState() =>
      _GeneralMovimientoDialogState();
}

class _GeneralMovimientoDialogState extends State<_GeneralMovimientoDialog> {
  late DateTime _fecha;
  final TextEditingController _conceptoController = TextEditingController();
  final TextEditingController _montoEfectivoController =
      TextEditingController();
  final TextEditingController _montoVirtualController =
      TextEditingController();
  final TextEditingController _detalleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fecha = widget.initialDate;
    _conceptoController.text = widget.initialConcepto ?? '';
    _montoEfectivoController.text = widget.initialMontoEfectivo?.toString() ?? '';
    _montoVirtualController.text =
        widget.initialMontoVirtual?.toString() ?? '';
    _detalleController.text = widget.initialDetalle ?? '';
  }

  @override
  void dispose() {
    _conceptoController.dispose();
    _montoEfectivoController.dispose();
    _montoVirtualController.dispose();
    _detalleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Movimiento general'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _conceptoController,
              decoration: const InputDecoration(labelText: 'Concepto'),
            ),
            TextField(
              controller: _montoEfectivoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto efectivo'),
            ),
            TextField(
              controller: _montoVirtualController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto virtual'),
            ),
            TextField(
              controller: _detalleController,
              decoration: const InputDecoration(labelText: 'Detalle'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Fecha:'),
                const SizedBox(width: 8),
                Text(_fmtDate(_fecha)),
                const Spacer(),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Cambiar'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (!mounted) {
      return;
    }
    if (picked != null) {
      setState(() => _fecha = picked);
    }
  }

  void _submit() {
    final concepto = _conceptoController.text.trim();
    if (concepto.isEmpty) {
      _showMessage(context, 'Completa el concepto.');
      return;
    }

    final montoEfectivo = _parseOptionalInt(_montoEfectivoController.text);
    final montoVirtual = _parseOptionalInt(_montoVirtualController.text);

    Navigator.of(context).pop(
      _GeneralMovimientoResult(
        fecha: _fecha,
        concepto: concepto,
        montoEfectivo: montoEfectivo,
        montoVirtual: montoVirtual,
        detalle: _detalleController.text.trim(),
      ),
    );
  }
}

int? _parseOptionalInt(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return int.tryParse(trimmed);
}
