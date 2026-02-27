import 'package:flutter/material.dart';
import '../services/api.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final TextEditingController controller = TextEditingController();

  String? gender;
  bool loading = false;

  Future<void> predictGender() async {
    final name = controller.text.trim();

    if (name.isEmpty) return;

    setState(() {
      loading = true;
    });

    try {
      final data = await ApiService.getGender(name);

      setState(() {
        gender = data["gender"];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error consultando API")),
      );
    }

    setState(() {
      loading = false;
    });
  }
Widget fadeSlideIn({required bool show, required Widget child}) {
  return AnimatedSlide(
    duration: const Duration(milliseconds: 250),
    offset: show ? Offset.zero : const Offset(0, 0.05),
    child: AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: show ? 1 : 0,
      child: child,
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;

    if (gender == "male") {
      backgroundColor = Colors.blue.shade200;
    } else if (gender == "female") {
      backgroundColor = Colors.pink.shade200;
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: const Text("Predecir Género")),
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
              onPressed: loading ? null : predictGender,
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Predecir"),
            ),
            const SizedBox(height: 20),
            if (gender != null)
              Text(
                "Género: $gender",
                style: const TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}