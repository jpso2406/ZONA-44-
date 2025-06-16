import '../models/carrito_item.dart';

abstract class CarritoState {}

class CarritoInicial extends CarritoState {}

class CarritoActualizado extends CarritoState {
  final List<CarritoItem> items;

  CarritoActualizado(this.items);
}
