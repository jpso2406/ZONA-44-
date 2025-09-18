import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zona44app/exports/exports.dart';

class OrderService {
  final String baseUrl;

  const OrderService({this.baseUrl = backendBaseUrl});

  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> cart,
    Map<String, dynamic>? customer,
    int? totalAmount,
  }) async {
    final uri = Uri.parse('$baseUrl/orders');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cart': cart,
        'customer': customer ?? {},
        'total_amount': totalAmount ?? 0,
      }),
    );
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
  }) async {
    final uri = Uri.parse('$baseUrl/orders/$orderId/pay');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
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
}
