import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zona44app/config/backend_config.dart';
import 'package:zona44app/models/user.dart';
import 'package:zona44app/models/order.dart';

class UserService {
  final String baseUrl;
  final GoogleSignIn _googleSignIn;

  UserService({this.baseUrl = backendBaseUrl}) : _googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> registerUser(User user, String password) async {
    final uri = Uri.parse('$baseUrl/register');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': user.toJson()..addAll({'password': password}),
      }),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception(
      'Error registrando usuario: \\${res.statusCode} \\${res.body}',
    );
  }

  Future<User> getProfile(String token) async {
    final uri = Uri.parse('$baseUrl/profile');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return User.fromJson(jsonDecode(res.body));
    }
    throw Exception(
      'Error obteniendo perfil: \\${res.statusCode} \\${res.body}',
    );
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final uri = Uri.parse('$baseUrl/login');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'auth': {'email': email, 'password': password},
      }),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Error en login: \\${res.statusCode} \\${res.body}');
  }

  Future<List<Order>> getUserOrders(String token) async {
    final uri = Uri.parse('$baseUrl/user_orders');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => Order.fromJson(json)).toList();
    }
    throw Exception(
      'Error obteniendo historial de órdenes: \\${res.statusCode} \\${res.body}',
    );
  }

  /// Obtiene los 50 pedidos más recientes (solo admin)
  Future<List<Order>> getAdminOrders(String token) async {
    final uri = Uri.parse('$baseUrl/admin/orders');
    final res = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => Order.fromJson(json)).toList();
    }
    throw Exception(
      'Error obteniendo órdenes admin: \\${res.statusCode} \\${res.body}',
    );
  }

  /// Cambia el estado de un pedido (solo admin)
  Future<Order> updateOrderStatus(
    String token,
    int orderId,
    String newStatus,
  ) async {
    final uri = Uri.parse('$baseUrl/admin/orders/$orderId');
    final res = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'status': newStatus}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Order.fromJson(jsonDecode(res.body));
    }
    throw Exception(
      'Error actualizando estado: \\${res.statusCode} \\${res.body}',
    );
  }

  /// Actualiza el perfil del usuario
  Future<Map<String, dynamic>> updateProfile(String token, User user) async {
    final uri = Uri.parse('$baseUrl/profile');
    final res = await http.put(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
      body: jsonEncode({'user': user.toJson()}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception(
      'Error actualizando perfil: \\${res.statusCode} \\${res.body}',
    );
  }

  /// Elimina la cuenta del usuario
  Future<Map<String, dynamic>> deleteAccount(String token) async {
    final uri = Uri.parse('$baseUrl/profile');
    final res = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json', 'Authorization': token},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception(
      'Error eliminando cuenta: \\${res.statusCode} \\${res.body}',
    );
  }

  /// Autenticación con Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Inicio de sesión cancelado por el usuario');
      }

      // Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('No se pudo obtener el token de ID de Google');
      }

      // Enviar el token al backend
      final uri = Uri.parse('$baseUrl/auth/google');
      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': googleAuth.idToken}),
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final responseData = jsonDecode(res.body) as Map<String, dynamic>;

        if (responseData['success'] == true) {
          return {
            'success': true,
            'user_id': responseData['user']['id'],
            'token': responseData['api_token'],
            'user_data': responseData['user'],
          };
        } else {
          throw Exception(
            responseData['error'] ?? 'Error en autenticación con Google',
          );
        }
      } else {
        throw Exception('Error del servidor: ${res.statusCode} ${res.body}');
      }
    } catch (e) {
      // Cerrar sesión de Google si hay error
      await _googleSignIn.signOut();
      rethrow;
    }
  }

  /// Cerrar sesión de Google
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
