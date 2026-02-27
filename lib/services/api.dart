import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> getGender(String name) async {
    final response = await http.get(
      Uri.parse('https://api.genderize.io/?name=$name'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al consultar la API');
    }
  }

  static Future<Map<String, dynamic>> getAge(String name) async {
  final response = await http.get(
    Uri.parse('https://api.agify.io/?name=$name'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Error al consultar edad');
  }
}

static Future<List<dynamic>> getUniversities(String country) async {
  final url = 'https://adamix.net/proxy.php?country=${Uri.encodeComponent(country)}';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception('Error al consultar universidades');
  }
}

static Future<Map<String, dynamic>> getWeatherRD() async {
  final url =
      "https://api.open-meteo.com/v1/forecast?latitude=18.48&longitude=-69.93&current_weather=true";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Error consultando clima");
  }
}


static Future<Map<String, dynamic>> getPokemon(String name) async {
  final url = "https://pokeapi.co/api/v2/pokemon/${name.toLowerCase().trim()}";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    throw Exception("Pokémon no encontrado");
  }
}

static Future<List<dynamic>> getWpPosts() async {
  const url = "https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  } else {
    throw Exception("Error consultando noticias WordPress");
  }
}


}

