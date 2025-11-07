class Producto {
  final int id;
  final String name;
  final int precio;
  final String descripcion;
  final String fotoUrl;
  final bool esPromocion;
  final int? promocionId;
  final int? precioOriginal;

  Producto({
    required this.id,
    required this.name,
    required this.precio,
    required this.descripcion,
    required this.fotoUrl,
    this.esPromocion = false,
    this.promocionId,
    this.precioOriginal,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      name: json['name'],
      precio: json['precio'],
      descripcion: json['descripcion'],
      fotoUrl: json['foto_url'],
      esPromocion: json['es_promocion'] ?? false,
      promocionId: json['promocion_id'],
      precioOriginal: json['precio_original'],
    );
  }
}