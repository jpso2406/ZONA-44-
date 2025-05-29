import 'package:equatable/equatable.dart';

class Plato extends Equatable {
  final int id;
  final String nombre;
  final String? descripcion; // ← Hacerlo opcional
  final double precio;
  final String categoria;

  const Plato({
    required this.id,
    required this.nombre,
    this.descripcion, // ← Acepta null
    required this.precio,
    required this.categoria,
  });

 factory Plato.fromJson(Map<String, dynamic> json) => Plato(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'] ?? json['descripción'], // <-- Soporta ambas
        precio: (json['precio'] as num).toDouble(),
        categoria: json['categoria'] ?? json['categoría'], // <-- También puede tener tilde
      );

  @override
  List<Object?> get props => [id, nombre, descripcion, precio, categoria];
}
  