import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zona44app/config/backend_config.dart';
import 'package:zona44app/models/promocion.dart';

class PromocionService {
  final String baseUrl;

  PromocionService({this.baseUrl = backendBaseUrl});

  /// Obtiene todas las promociones públicas (sin autenticación)
  Future<List<Promocion>> getPromocionesPublicas() async {
    final uri = Uri.parse('$baseUrl/promociones/public');

    try {
      final res = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => Promocion.fromJson(json)).toList();
      }

      throw Exception(
        'Error obteniendo promociones: ${res.statusCode} ${res.body}',
      );
    } catch (e) {
      print('Error en getPromocionesPublicas: $e');
      return [];
    }
  }

  /// Obtiene todas las promociones (requiere autenticación admin)
  Future<List<Promocion>> getPromociones(String token) async {
    final uri = Uri.parse('$baseUrl/promociones');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => Promocion.fromJson(json)).toList();
    }

    throw Exception(
      'Error obteniendo promociones: ${res.statusCode} ${res.body}',
    );
  }

  /// Obtiene una promoción específica (requiere autenticación admin)
  Future<Promocion> getPromocion(String token, int id) async {
    final uri = Uri.parse('$baseUrl/promociones/$id');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Promocion.fromJson(jsonDecode(res.body));
    }

    throw Exception(
      'Error obteniendo promoción: ${res.statusCode} ${res.body}',
    );
  }
}
