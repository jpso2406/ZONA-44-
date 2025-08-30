import 'producto.dart';

class Grupo {
  final int id;
  final String nombre;
  final String slug;
  final String fotoUrl; // Agregar esta propiedad
  final List<Producto> productos;

  Grupo({
    required this.id,
    required this.nombre,
    required this.slug,
    required this.fotoUrl, // Agregar este parámetro
    required this.productos,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      nombre: json['nombre'],
      slug: json['slug'],
      fotoUrl: json['foto_url'], // Mapear desde JSON
      productos: (json['productos'] as List)
          .map((producto) => Producto.fromJson(producto))
          .toList(),
    );
  }
}