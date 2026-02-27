import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/gender_screen.dart';
import 'screens/age_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/wp_news_screen.dart';
import 'screens/about_screen.dart';

void main() => runApp(const ToolboxApp());

class ToolboxApp extends StatelessWidget {
  const ToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toolbox App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const MainTabs(),
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int index = 0;

  final pages = const [
    HomeScreen(),
    GenderScreen(),
    AgeScreen(),
    UniversitiesScreen(),
    WeatherScreen(),
    PokemonScreen(),
    WpNewsScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
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