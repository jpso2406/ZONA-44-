import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plato.dart';

class PlatoRepository {
  final String url = 'https://run.mocky.io/v3/3da66479-4095-477a-9f34-b122c1f71bc9';

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