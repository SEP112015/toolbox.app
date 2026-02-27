import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onGoToTab});

  final void Function(int tabIndex) onGoToTab;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required int tabIndex,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => widget.onGoToTab(tabIndex),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: scheme.surfaceContainerHighest.withOpacity(0.6),
          border: Border.all(color: scheme.outlineVariant.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: scheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: scheme.outline),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [
                          scheme.primaryContainer,
                          scheme.secondaryContainer,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Toolbox Dashboard",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Accede rápido a cada herramienta",
                          style: TextStyle(color: scheme.onPrimaryContainer.withOpacity(0.85)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Quick actions
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => widget.onGoToTab(1),
                          icon: const Icon(Icons.wc),
                          label: const Text("Género"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => widget.onGoToTab(2),
                          icon: const Icon(Icons.cake),
                          label: const Text("Edad"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Expanded(
                    child: ListView(
                      children: [
                        _tile(
                          icon: Icons.school,
                          title: "Universidades",
                          subtitle: "Busca universidades por país (en inglés)",
                          tabIndex: 3,
                        ),
                        const SizedBox(height: 10),
                        _tile(
                          icon: Icons.cloud,
                          title: "Clima RD",
                          subtitle: "Consulta el clima actual en Santo Domingo",
                          tabIndex: 4,
                        ),
                        const SizedBox(height: 10),
                        _tile(
                          icon: Icons.catching_pokemon,
                          title: "Pokémon",
                          subtitle: "Foto, experiencia, habilidades y sonido",
                          tabIndex: 5,
                        ),
                        const SizedBox(height: 10),
                        _tile(
                          icon: Icons.rss_feed,
                          title: "WordPress News",
                          subtitle: "Últimas 3 noticias + link original",
                          tabIndex: 6,
                        ),
                        const SizedBox(height: 10),
                        _tile(
                          icon: Icons.info,
                          title: "Acerca de",
                          subtitle: "Tu foto y contacto para trabajos",
                          tabIndex: 7,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}