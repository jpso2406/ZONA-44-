import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plato.dart';

class PlatoRepository {
  final String url = 'https://run.mocky.io/v3/e9944dd0-9b5b-4306-9e7d-01077c1b0a91';

  Future<List<Plato>> obtenerPlatos() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Plato.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los platos');
    }
  }
}