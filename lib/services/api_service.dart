import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = dotenv.env['BACKEND_URL']!;

  // POST request
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('POST $endpoint failed: ${response.statusCode}');
    }
  }

  // GET request
  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('GET $endpoint failed: ${response.statusCode}');
    }
  }

  // PUT request
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('PUT $endpoint failed: ${response.statusCode}');
    }
  }

  // DELETE request
  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('DELETE $endpoint failed: ${response.statusCode}');
    }
  }
}
