import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grupo.dart';

class MenuService {
  static const String baseUrl = 'http://localhost:3000/api/v1';

  Future<List<Grupo>> getGrupos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/grupos'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Grupo.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar el menú: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}