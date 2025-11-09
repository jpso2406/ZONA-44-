import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zona44app/models/order.dart';
import 'package:zona44app/exports/exports.dart';

// Servicio para manejar la creación y pago de órdenes en el backend
class OrderService {
  final String baseUrl;

  const OrderService({this.baseUrl = backendBaseUrl});

  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> cart,
    Map<String, dynamic>? customer,
    int? totalAmount,
    String? deliveryType,
    String? authToken,
    int? userId,
  }) async {
    final uri = Uri.parse('$baseUrl/orders');
    final headers = {'Content-Type': 'application/json'};

    // Agregar token de autenticación si está disponible
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = authToken;
    }

    final body = {
      'cart': cart,
      'customer': customer ?? {},
      'total_amount': totalAmount ?? 0,
    };
    if (deliveryType != null) {
      body['delivery_type'] = deliveryType;
    }
    // ⚠️ CRÍTICO: Incluir user_id si está disponible
    if (userId != null) {
      body['user_id'] = userId;
    }
    final res = await http.post(uri, headers: headers, body: jsonEncode(body));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Error creando orden: ${res.statusCode} ${res.body}');
  }

  Future<Map<String, dynamic>> payOrder({
    required int orderId,
    required String cardNumber,
    required String cardExpiration,
    required String cardCvv,
    required String cardName,
    String? authToken,
  }) async {
    final uri = Uri.parse('$baseUrl/orders/$orderId/pay');
    final headers = {'Content-Type': 'application/json'};

    // Agregar token de autenticación si está disponible
    if (authToken != null && authToken.isNotEmpty) {
      headers['Authorization'] = authToken;
    }

    final res = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({
        'card_number': cardNumber,
        'card_expiration': cardExpiration,
        'card_cvv': cardCvv,
        'card_name': cardName,
      }),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Error pagando orden: ${res.statusCode} ${res.body}');
  }

  /// Busca una orden por número de orden y email (para clientes no logueados)
  Future<Order> trackOrder({
    required String orderNumber,
    required String email,
  }) async {
    final uri = Uri.parse('$baseUrl/orders/track');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'order_number': orderNumber, 'email': email}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final data = jsonDecode(res.body);

      // Debug: Imprimir respuesta del backend
      print('🔍 Backend Response: ${res.body}');

      // El backend devuelve {"success": true, "order": {...}}
      final orderData = data['order'] ?? data;
      print('🔍 Order Items from backend: ${orderData['order_items']}');
      print(
        '🔍 Debug Order Items: ${(orderData['order_items'] as List?)?.length ?? 0}',
      );

      return Order.fromJson(orderData);
    }
    throw Exception('Error buscando orden: ${res.statusCode} ${res.body}');
  }

  /// Obtiene estadísticas de órdenes huérfanas
  Future<Map<String, dynamic>> getOrphanedStats() async {
    final uri = Uri.parse('$baseUrl/orders/orphaned_stats');
    final res = await http.get(uri);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    throw Exception(
      'Error obteniendo estadísticas: ${res.statusCode} ${res.body}',
    );
  }

  /// Limpia órdenes huérfanas (pendientes de usuarios no logueados)
  Future<Map<String, dynamic>> cleanupOrphanedOrders() async {
    final uri = Uri.parse('$baseUrl/orders/cleanup_orphaned');
    final res = await http.delete(uri);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    throw Exception(
      'Error limpiando órdenes huérfanas: ${res.statusCode} ${res.body}',
    );
  }
}
