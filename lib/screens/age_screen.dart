import 'package:flutter/material.dart';
import '../services/api.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final TextEditingController controller = TextEditingController();

  int? age;
  String? category;
  bool loading = false;

  Future<void> predictAge() async {
    final name = controller.text.trim();
    if (name.isEmpty) return;

    setState(() {
      loading = true;
    });

    try {
      final data = await ApiService.getAge(name);

      age = data["age"];

      if (age != null) {
        if (age! <= 25) {
          category = "Joven";
        } else if (age! <= 59) {
          category = "Adulto";
        } else {
          category = "Anciano";
        }
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error consultando API")),
      );
    }

    setState(() {
      loading = false;
    });
  }

  String getImage() {
    if (category == "Joven") {
      return "assets/images/young.png";
    } else if (category == "Adulto") {
      return "assets/images/adult.png";
    } else {
      return "assets/images/elder.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Predecir Edad")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Escribe un nombre",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: loading ? null : predictAge,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Predecir Edad"),
            ),
            const SizedBox(height: 20),
            if (age != null)
              Column(
                children: [
                  Text(
                    "Edad estimada: $age",
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Categoría: $category",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  Image.asset(
                    getImage(),
                    height: 120,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}