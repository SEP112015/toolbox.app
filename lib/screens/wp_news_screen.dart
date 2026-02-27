import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/launch.dart';

class WpNewsScreen extends StatefulWidget {
  const WpNewsScreen({super.key});

  @override
  State<WpNewsScreen> createState() => _WpNewsScreenState();
}

class _WpNewsScreenState extends State<WpNewsScreen> {
  bool loading = false;
  String? error;
  List<Map<String, String>> posts = [];

  // ✅ API que puedes publicar en el foro:
  final String apiUrl = "https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3";

  String stripHtml(String input) {
    return input
        .replaceAll(RegExp(r"<[^>]*>"), " ")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();
  }

  Future<void> fetchNews() async {
    setState(() {
      loading = true;
      error = null;
      posts = [];
    });

    try {
      final data = await ApiService.getWpPosts();

      final mapped = data.take(3).map((e) {
        final m = e as Map<String, dynamic>;
        final title = (m["title"]?["rendered"] ?? "").toString();
        final excerpt = (m["excerpt"]?["rendered"] ?? "").toString();
        final link = (m["link"] ?? "").toString();

        return {
          "title": stripHtml(title),
          "excerpt": stripHtml(excerpt),
          "link": link,
        };
      }).toList();

      setState(() => posts = mapped);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Noticias WordPress")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset("assets/images/wp_logo.png", width: 44, height: 44),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Últimas 3 noticias (WordPress News)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText("API: $apiUrl", style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),

            FilledButton.icon(
              onPressed: loading ? null : fetchNews,
              icon: const Icon(Icons.refresh),
              label: const Text("Actualizar"),
            ),

            const SizedBox(height: 12),
            if (loading) const LinearProgressIndicator(),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 8),

            Expanded(
              child: posts.isEmpty
                  ? const Center(child: Text("Sin noticias aún"))
                  : ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (_, i) {
                        final p = posts[i];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p["title"] ?? "",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(p["excerpt"] ?? ""),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () => openUrl(p["link"] ?? ""),
                                    icon: const Icon(Icons.open_in_new),
                                    label: const Text("Visitar"),
                                  ),
                                ),
                              ],
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