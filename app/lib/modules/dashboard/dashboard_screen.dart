import 'package:flutter/material.dart';

import '../../core/session.dart';
import '../hh/hh_abm_screen.dart';
import '../hh/hh_list_screen.dart';
import '../home/home_screen.dart';
import '../tesoreria/tesoreria_abm_screen.dart';
import '../tesoreria/tesoreria_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.session,
    required this.onLogout,
  });

  final UserSession session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return _DashboardShell(
      session: session,
      onLogout: onLogout,
    );
  }
}

class _DashboardShell extends StatefulWidget {
  const _DashboardShell({required this.session, required this.onLogout});

  final UserSession session;
  final VoidCallback onLogout;

  @override
  State<_DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<_DashboardShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        session: widget.session,
        onOpenOperations: () => _showOperations(context),
        onOpenProfile: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil pendiente de implementar.')),
          );
        },
      ),
      const HhListScreen(),
      TesoreriaScreen(session: widget.session, readOnly: true),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list_outlined),
            activeIcon: Icon(Icons.view_list),
            label: 'Cuadro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Tesoreria',
          ),
        ],
      ),
    );
  }

  void _showOperations(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const ListTile(
                title: Text('Operaciones'),
              ),
              if (widget.session.rolGestion == 'VM' ||
                  widget.session.rolGestion == 'Secretario')
                ListTile(
                  leading: const Icon(Icons.group_add),
                  title: const Text('ABM HH'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HhAbmScreen()),
                    );
                  },
                ),
              if (widget.session.rolGestion == 'VM' ||
                  widget.session.rolGestion == 'Tesorero')
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: const Text('ABM Tesoreria'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TesoreriaAbmScreen(
                          session: widget.session,
                        ),
                      ),
                    );
                  },
                ),
              if (widget.session.rolGestion == 'VM' ||
                  widget.session.rolGestion == 'Admin')
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuracion'),
                  onTap: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Configuracion pendiente de implementar.'),
                      ),
                    );
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Salir'),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onLogout();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
