import 'package:zona44app/models/producto.dart';

class Promocion {
  final int id;
  final String nombre;
  final double precioTotal;
  final double precioOriginal;
  final double descuento;
  final int? productoId;
  final String? imagenUrl;
  final DateTime? createdAt;
  final PromocionProducto? producto;

  Promocion({
    required this.id,
    required this.nombre,
    required this.precioTotal,
    required this.precioOriginal,
    required this.descuento,
    this.productoId,
    this.imagenUrl,
    this.createdAt,
    this.producto,
  });

  /// Convierte la promoción en un Producto para agregar al carrito
  /// El precio será el precio promocional
  Producto toProducto() {
    return Producto(
      id:
          id *
          -1, // ID negativo para diferenciar promociones de productos normales
      name: nombre,
      precio: precioTotal.toInt(),
      descripcion: 'Promoción - Ahorra ${descuento.toInt()}%',
      fotoUrl: imagenUrl ?? '',
      esPromocion: true,
      promocionId: id,
      precioOriginal: precioOriginal.toInt(),
    );
  }

  factory Promocion.fromJson(Map<String, dynamic> json) {
    return Promocion(
      id: json['id'] ?? 0,
      nombre: json['nombre']?.toString() ?? '',
      precioTotal: (json['precio_total'] is num)
          ? (json['precio_total'] as num).toDouble()
          : double.tryParse(json['precio_total']?.toString() ?? '0') ?? 0.0,
      precioOriginal: (json['precio_original'] is num)
          ? (json['precio_original'] as num).toDouble()
          : double.tryParse(json['precio_original']?.toString() ?? '0') ?? 0.0,
      descuento: (json['descuento'] is num)
          ? (json['descuento'] as num).toDouble()
          : double.tryParse(json['descuento']?.toString() ?? '0') ?? 0.0,
      productoId: json['producto_id'],
      imagenUrl: json['imagen_url']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      producto: json['producto'] != null
          ? PromocionProducto.fromJson(json['producto'])
          : null,
    );
  }
}

class PromocionProducto {
  final int id;
  final String name;
  final double precio;
  final String descripcion;

  PromocionProducto({
    required this.id,
    required this.name,
    required this.precio,
    required this.descripcion,
  });

  factory PromocionProducto.fromJson(Map<String, dynamic> json) {
    return PromocionProducto(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      precio: (json['precio'] is num)
          ? (json['precio'] as num).toDouble()
          : double.tryParse(json['precio']?.toString() ?? '0') ?? 0.0,
      descripcion: json['descripcion']?.toString() ?? '',
    );
  }
}
