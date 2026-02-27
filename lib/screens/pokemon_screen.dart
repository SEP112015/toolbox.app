import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final controller = TextEditingController(text: "pikachu");
  final player = AudioPlayer();

  bool loading = false;
  String? error;

  String? pokemonName;
  String? imageUrl;
  int? baseExp;
  List<String> abilities = [];
  String? cryLatestUrl;

  Future<void> fetchPokemon() async {
    final name = controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      loading = true;
      error = null;
      pokemonName = null;
      imageUrl = null;
      baseExp = null;
      abilities = [];
      cryLatestUrl = null;
    });

    try {
      final data = await ApiService.getPokemon(name);

      // Nombre
      final n = (data["name"] ?? "").toString();

      // Experiencia base
      final exp = (data["base_experience"] as num?)?.toInt();

      // Habilidades
      final ab = (data["abilities"] as List)
          .map((e) => (e["ability"]["name"]).toString())
          .toList();

      // Imagen (official artwork preferida)
      final sprites = data["sprites"] as Map<String, dynamic>;
      final other = sprites["other"] as Map<String, dynamic>?;
      final official = other?["official-artwork"] as Map<String, dynamic>?;
      final img = (official?["front_default"] ?? sprites["front_default"])?.toString();

      // Sonido latest
      final cries = data["cries"] as Map<String, dynamic>?;
      final cry = cries?["latest"]?.toString();

      setState(() {
        pokemonName = n;
        baseExp = exp;
        abilities = ab.cast<String>();
        imageUrl = img;
        cryLatestUrl = cry;
      });
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> playCry() async {
    if (cryLatestUrl == null || cryLatestUrl!.isEmpty) return;
    await player.stop();
    await player.play(UrlSource(cryLatestUrl!));
  }

  @override
  void dispose() {
    controller.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pokémon")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Nombre del Pokémon (ej: pikachu)",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => fetchPokemon(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loading ? null : fetchPokemon,
              child: loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Buscar"),
            ),
            const SizedBox(height: 12),

            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 8),

            Expanded(
              child: pokemonName == null
                  ? const Center(child: Text("Busca un Pokémon para ver sus datos"))
                  : ListView(
                      children: [
                        if (imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              imageUrl!,
                              height: 220,
                              fit: BoxFit.contain,
                            ),
                          ),
                        const SizedBox(height: 12),

                        Card(
                          child: ListTile(
                            title: Text("Nombre: $pokemonName"),
                            subtitle: Text("Experiencia base: ${baseExp ?? 0}"),
                          ),
                        ),

                        Card(
                          child: ListTile(
                            title: const Text("Habilidades"),
                            subtitle: Text(abilities.isEmpty ? "N/A" : abilities.join(", ")),
                          ),
                        ),

                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: (cryLatestUrl == null || cryLatestUrl!.isEmpty) ? null : playCry,
                          icon: const Icon(Icons.volume_up),
                          label: const Text("Reproducir sonido (latest)"),
                        ),

                        if (cryLatestUrl != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text("Audio: $cryLatestUrl", style: const TextStyle(fontSize: 12)),
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