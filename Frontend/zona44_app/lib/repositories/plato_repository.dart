import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plato.dart';

class PlatoRepository {
  final String url = 'https://run.mocky.io/v3/b23867f7-8dd6-4cab-9061-4b8f1f4a470a';

  Future<List<Plato>> obtenerPlatos() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Plato.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los platos');
    }
  }
}