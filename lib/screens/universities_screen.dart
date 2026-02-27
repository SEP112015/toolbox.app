import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/launch.dart';
import 'package:url_launcher/url_launcher.dart';
class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final controller = TextEditingController(text: "Dominican Republic");

  bool loading = false;
  String? error;
  List<dynamic> universities = [];

  Future<void> fetchUniversities() async {
    final country = controller.text.trim();
    if (country.isEmpty) return;

    setState(() {
      loading = true;
      error = null;
      universities = [];
    });
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No pude abrir el enlace")),
    );
  }
}
    try {
      final list = await ApiService.getUniversities(country);
      setState(() => universities = list);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Universidades por país")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "País (en inglés)",
                hintText: "Ej: Dominican Republic",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => fetchUniversities(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loading ? null : fetchUniversities,
              child: loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Buscar"),
            ),
            const SizedBox(height: 12),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            Expanded(
              child: universities.isEmpty
                  ? const Center(child: Text("Sin resultados"))
                  : ListView.builder(
                      itemCount: universities.length,
                      itemBuilder: (_, i) {
                        final u = universities[i] as Map<String, dynamic>;
                        final name = (u["name"] ?? "").toString();

                        final domains = (u["domains"] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            [];

                        final webPages = (u["web_pages"] as List?)
                                ?.map((e) => e.toString())
                                .toList() ??
                            [];

                        final link = webPages.isNotEmpty ? webPages.first : null;

                        return Card(
                          child: ListTile(
                            title: Text(name),
                            subtitle: Text(
                              "Dominio(s): ${domains.isEmpty ? "N/A" : domains.join(", ")}\n"
                              "Web: ${link ?? "N/A"}",
                            ),
                            trailing: link == null
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.open_in_new),
                                    onPressed: () => openUrl(link),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}