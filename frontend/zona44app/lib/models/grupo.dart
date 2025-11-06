import 'producto.dart';

class Grupo {
  final int id;
  final String nombre;
  final String slug;
  final String fotoUrl;
  final List<Producto> productos;

  Grupo({
    required this.id,
    required this.nombre,
    required this.slug,
    required this.fotoUrl,
    this.productos = const [],
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      nombre: json['nombre'],
      slug: json['slug'],
      fotoUrl: json['foto_url'],
      productos: json['productos'] != null
          ? (json['productos'] as List)
                .map((producto) => Producto.fromJson(producto))
                .toList()
          : [],
    );
  }
}
