import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/session.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.session,
    required this.onOpenOperations,
    required this.onOpenProfile,
  });

  final UserSession session;
  final VoidCallback onOpenOperations;
  final VoidCallback onOpenProfile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _autoSlideTimer;

  final List<String> _filters = [
    'Todo',
    'Efemerides',
    'Cumpleanos',
    'Tenidas',
  ];

  final List<_NovedadCard> _cards = const [
    _NovedadCard(
      title: 'Efemeride masonica',
      subtitle: '1813 - Asamblea del Año XIII',
      date: 'Hoy',
      color: Color(0xFF274C77),
    ),
    _NovedadCard(
      title: 'Cumpleanos',
      subtitle: 'G. Monti · 24/08',
      date: 'Proximo',
      color: Color(0xFF6096BA),
    ),
    _NovedadCard(
      title: 'Tenida ordinaria',
      subtitle: 'Viernes 2do · 20:30',
      date: 'Esta semana',
      color: Color(0xFF3C6E71),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _cards.length < 2) {
        return;
      }
      final nextPage = (_currentPage + 1) % _cards.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final greetingName = widget.session.displayName;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onOpenOperations,
                  icon: const Icon(Icons.menu),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onOpenProfile,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF6096BA),
                    child: Text(
                      greetingName.isNotEmpty
                          ? greetingName.characters.first
                          : 'H',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Hola, $greetingName',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Taller Fraternitas 547',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _FilterChips(
              filters: _filters,
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 190,
              child: PageView.builder(
                controller: _controller,
                itemCount: _cards.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                physics: const PageScrollPhysics(),
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.only(
                      right: index == _cards.length - 1 ? 0 : 12,
                    ),
                    child: _NovedadCardView(card: card),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_cards.length, (index) {
                final active = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: active ? 22 : 8,
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF274C77)
                        : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
            const SizedBox(height: 22),
            Text(
              'Tesoreria',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
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
                    'Deuda actual',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$28.000',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF274C77),
                            ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Notificacion pendiente.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.notifications_active),
                        label: const Text('Notificar pago'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ultimo movimiento: 03/01/2026',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatefulWidget {
  const _FilterChips({required this.filters});

  final List<String> filters;

  @override
  State<_FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<_FilterChips> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(widget.filters.length, (index) {
        final selected = index == _selectedIndex;
        return ChoiceChip(
          label: Text(widget.filters[index]),
          selected: selected,
          onSelected: (_) => setState(() => _selectedIndex = index),
          selectedColor: const Color(0xFF274C77),
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
        );
      }),
    );
  }
}

class _NovedadCard {
  const _NovedadCard({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String date;
  final Color color;
}

class _NovedadCardView extends StatelessWidget {
  const _NovedadCardView({required this.card});

  final _NovedadCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            card.color,
            card.color.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.date,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const Spacer(),
          Text(
            card.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            card.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}
