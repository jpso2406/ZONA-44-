class Plato {
  final String nombre;
  final String descripcion;
  final double precio;

  Plato({
    required this.nombre,
    required this.descripcion,
    required this.precio,
  });

  factory Plato.fromJson(Map<String, dynamic> json) {
    return Plato(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
    );
  }
}