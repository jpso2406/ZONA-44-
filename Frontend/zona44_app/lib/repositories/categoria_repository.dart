import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/categoria.dart';

class CategoriaRepository {
  final String url = 'https://run.mocky.io/v3/a6f21f94-e86d-4bfc-861d-014c1f0a5a77'; 

  Future<List<Categoria>> obtenerCategorias() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar las categorías');
    }
  }
}
