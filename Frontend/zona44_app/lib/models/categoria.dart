class Categoria {
  final String nombre;
  final String imagenUrl;

  Categoria({
    required this.nombre,
    required this.imagenUrl,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      nombre: json['nombre'],
      imagenUrl: json['imagenUrl'],
    );
  }
}
