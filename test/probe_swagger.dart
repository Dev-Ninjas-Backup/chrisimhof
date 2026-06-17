import 'package:http/http.dart' as http;

void main() async {
  final baseUrl = 'https://api.ryvenza.app';
  final paths = ['/api', '/api/docs', '/docs', '/swagger', '/swagger-ui', '/api/v1'];

  for (var path in paths) {
    try {
      final res = await http.get(Uri.parse('$baseUrl$path')).timeout(const Duration(seconds: 5));
      print('$path: ${res.statusCode} (length: ${res.body.length})');
      if (res.statusCode == 200 && res.body.contains('swagger')) {
        print('Found Swagger/Docs at $path!');
      }
    } catch (e) {
      print('$path failed: $e');
    }
  }
}
