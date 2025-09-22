class Producto {
  final int id;
  final String name;
  final int precio;
  final String descripcion;
  final String fotoUrl;

  Producto({
    required this.id,
    required this.name,
    required this.precio,
    required this.descripcion,
    required this.fotoUrl,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      name: json['name'],
      precio: json['precio'],
      descripcion: json['descripcion'],
      fotoUrl: json['foto_url'],
    );
  }
}