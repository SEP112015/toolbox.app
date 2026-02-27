import 'package:flutter/material.dart';
import '../services/launch.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const name = "Sebastián Pérez";
    const role = "Desarrollador de software y Científico de datos";
    const email = "prezs692@gmail.com";
    const phone = "+1 849-342-7188";
    const portfolio = "https://github.com/SEP112015";

    return Scaffold(
      appBar: AppBar(title: const Text("Acerca de")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: const AssetImage("assets/images/me.jpg"),
            ),
            const SizedBox(height: 15),

            const Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),
            const Text(role),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: const Text(email),
                onTap: () => openUrl("mailto:$email"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text("Teléfono"),
                subtitle: const Text(phone),
                onTap: () => openUrl("tel:$phone"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.public),
                title: const Text("GitHub"),
                subtitle: const Text(portfolio),
                onTap: () => openUrl(portfolio),
              ),
            ),
          ],
        ),
      ),
    );
  }
}