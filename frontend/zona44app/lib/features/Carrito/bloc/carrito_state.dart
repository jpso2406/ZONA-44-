part of 'carrito_bloc.dart';

sealed class CarritoState extends Equatable {
  const CarritoState();
  @override
  List<Object> get props => [];
}

class CarritoLoaded extends CarritoState {
  final List<CarritoItem> items;
  const CarritoLoaded(this.items);

  int get totalItems => items.fold(0, (s, it) => s + it.cantidad);
  int get totalPrecio => items.fold(0, (s, it) => s + (it.producto.precio * it.cantidad));

  @override
  List<Object> get props => [items];
}