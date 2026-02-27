import 'package:flutter/material.dart';
import '../services/api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool loading = false;
  Map<String, dynamic>? weather;

  Future<void> fetchWeather() async {
    setState(() => loading = true);

    try {
      final data = await ApiService.getWeatherRD();
      setState(() => weather = data["current_weather"]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error consultando clima")),
      );
    }

    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  IconData getWeatherIcon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code < 3) return Icons.cloud;
    if (code < 60) return Icons.grain;
    return Icons.thunderstorm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clima RD (Hoy)")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : weather == null
                ? const Text("No hay datos")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        getWeatherIcon(weather!["weathercode"]),
                        size: 80,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${weather!["temperature"]}°C",
                        style: const TextStyle(fontSize: 28),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Viento: ${weather!["windspeed"]} km/h",
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchWeather,
                        child: const Text("Actualizar"),
                      ),
                    ],
                  ),
      ),
    );
  }
}