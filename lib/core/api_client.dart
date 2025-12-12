import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  static const String baseUrl =
      'http://192.168.100.2:8000'; // Replace with your ipv4:8000

  Future<List<double>?> extractEmbedding(dynamic file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/extract-embedding'),
      );

      if (file is String) {
        request.files.add(await http.MultipartFile.fromPath('file', file));
      } else {
        request.files.add(
          http.MultipartFile.fromBytes('file', file, filename: 'frame.jpg'),
        );
      }

      var response = await request.send();
      var data = await response.stream.bytesToString();
      var jsonData = json.decode(data);

      if (jsonData.containsKey('error')) return null;
      return List<double>.from(jsonData['embedding']);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> findBestMatch(
    List<double> cameraEmbedding,
    List<List<double>> databaseEmbeddings,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/find-best-match'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'camera_embedding': cameraEmbedding,
          'database_embeddings': databaseEmbeddings,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'success': false};
    } catch (e) {
      return {'success': false};
    }
  }
}
