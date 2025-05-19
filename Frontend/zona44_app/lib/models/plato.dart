import 'package:equatable/equatable.dart';

class Plato extends Equatable {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;

  const Plato({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
  });

  factory Plato.fromJson(Map<String, dynamic> json) => Plato(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        precio: (json['precio'] as num).toDouble(),
        categoria: json['categoria'],
      );

  @override
  List<Object?> get props => [id, nombre, descripcion, precio, categoria];
}