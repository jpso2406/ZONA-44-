import 'producto.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;

  CarritoItem({
    required this.producto,
    this.cantidad = 1,
  });

  double get precioTotal => producto.precio * cantidad;

  CarritoItem copyWith({
    Producto? producto,
    int? cantidad,
  }) {
    return CarritoItem(
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CarritoItem && other.producto.id == producto.id;
  }

  @override
  int get hashCode => producto.id.hashCode;
}