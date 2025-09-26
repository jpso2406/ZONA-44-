import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zona44app/config/backend_config.dart';
import 'package:zona44app/models/user.dart';

class UserService {
  final String baseUrl;
  UserService({this.baseUrl = backendBaseUrl});

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
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Error en login: \\${res.statusCode} \\${res.body}');
  }
}
