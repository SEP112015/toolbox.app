import 'package:url_launcher/url_launcher.dart';
import '../services/launch.dart';
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('No pude abrir el link');
  }
}