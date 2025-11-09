import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zona44app/config/backend_config.dart';
import 'package:zona44app/models/table_reservation.dart';

class ReservationService {
  final String baseUrl;

  ReservationService({this.baseUrl = backendBaseUrl});

  /// Crea una nueva reserva de mesa
  /// No requiere autenticación
  Future<Map<String, dynamic>> createReservation(
    TableReservation reservation,
  ) async {
    final uri = Uri.parse('$baseUrl/table_reservations');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'table_reservation': reservation.toJson()}),
    );

    final responseData = jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return {
        'success': responseData['success'] ?? true,
        'reservation': responseData['reservation'] != null
            ? TableReservation.fromJson(responseData['reservation'])
            : null,
      };
    }

    return {
      'success': false,
      'errors': responseData['errors'] ?? ['Error al crear la reserva'],
    };
  }

  /// Obtiene todas las reservas del usuario autenticado
  Future<List<TableReservation>> getUserReservations(String token) async {
    final uri = Uri.parse('$baseUrl/table_reservations');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => TableReservation.fromJson(json)).toList();
    }

    throw Exception('Error obteniendo reservas: ${res.statusCode} ${res.body}');
  }

  /// Obtiene una reserva específica por ID
  Future<TableReservation> getReservation(String token, int id) async {
    final uri = Uri.parse('$baseUrl/table_reservations/$id');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return TableReservation.fromJson(jsonDecode(res.body));
    }

    throw Exception('Error obteniendo reserva: ${res.statusCode} ${res.body}');
  }

  /// Cancela una reserva
  Future<bool> cancelReservation(String token, int id) async {
    final uri = Uri.parse('$baseUrl/table_reservations/$id/cancel');
    final res = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final responseData = jsonDecode(res.body);
      return responseData['success'] ?? false;
    }

    return false;
  }
}
