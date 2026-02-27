import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/gender_screen.dart';
import 'screens/age_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/wp_news_screen.dart';
import 'screens/about_screen.dart';

void main() => runApp(const ToolboxApp());

class ToolboxApp extends StatefulWidget {
  const ToolboxApp({super.key});

  @override
  State<ToolboxApp> createState() => _ToolboxAppState();
}

class _ToolboxAppState extends State<ToolboxApp> {
  ThemeMode mode = ThemeMode.system; // system / light / dark

  void toggleTheme() {
    setState(() {
      mode = (mode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolbox App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      home: MainTabs(
        onToggleTheme: toggleTheme,
        themeMode: mode,
      ),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key, required this.onToggleTheme, required this.themeMode});

  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int index = 0;

 late final List<Widget> pages;

@override
void initState() {
  super.initState();
  pages = [
    HomeScreen(onGoToTab: (i) => setState(() => index = i)),
    const GenderScreen(),
    const AgeScreen(),
    const UniversitiesScreen(),
    const WeatherScreen(),
    const PokemonScreen(),
    const WpNewsScreen(),
    const AboutScreen(),
  ];
}
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Toolbox App"),
        actions: [
          IconButton(
            tooltip: "Modo oscuro",
            onPressed: widget.onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),

      // ✅ Animación suave al cambiar de pestaña
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: KeyedSubtree(
          key: ValueKey(index),
          child: pages[index],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Inicio"),
          NavigationDestination(icon: Icon(Icons.wc), label: "Género"),
          NavigationDestination(icon: Icon(Icons.cake), label: "Edad"),
          NavigationDestination(icon: Icon(Icons.school), label: "Uni"),
          NavigationDestination(icon: Icon(Icons.cloud), label: "Clima RD"),
          NavigationDestination(icon: Icon(Icons.catching_pokemon), label: "Pokémon"),
          NavigationDestination(icon: Icon(Icons.rss_feed), label: "WP News"),
          NavigationDestination(icon: Icon(Icons.info), label: "Acerca de"),
        ],
      ),
    );
  }
}