part of 'carrito_bloc.dart';

sealed class CarritoEvent extends Equatable {
  const CarritoEvent();
  @override
  List<Object> get props => [];
}

class AgregarProducto extends CarritoEvent {
  final Producto producto;
  const AgregarProducto(this.producto);
  @override
  List<Object> get props => [producto];
}

class RemoverProducto extends CarritoEvent {
  final int productoId;
  const RemoverProducto(this.productoId);
  @override
  List<Object> get props => [productoId];
}

class ActualizarCantidad extends CarritoEvent {
  final int productoId;
  final int cantidad;
  const ActualizarCantidad(this.productoId, this.cantidad);
  @override
  List<Object> get props => [productoId, cantidad];
}

class LimpiarCarrito extends CarritoEvent {}