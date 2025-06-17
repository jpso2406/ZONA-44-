import 'package:equatable/equatable.dart';

class Plato extends Equatable {
  final int id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String categoria;
  final String? imagen; // ✅ Nuevo campo

  const Plato({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    required this.categoria,
    this.imagen, // ✅ Nuevo parámetro
  });

  factory Plato.fromJson(Map<String, dynamic> json) => Plato(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'] ?? json['descripción'],
        precio: (json['precio'] as num).toDouble(),
        categoria: json['categoria'] ?? json['categoría'],
        imagen: json['imagen'], // ✅ Extrae la imagen del JSON
      );

  @override
  List<Object?> get props => [id, nombre, descripcion, precio, categoria, imagen];
}
