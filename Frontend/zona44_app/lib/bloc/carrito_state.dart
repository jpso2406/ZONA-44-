import '../models/carrito_item.dart';
import '../models/plato.dart';

abstract class CarritoState {}

class CarritoInicial extends CarritoState {}

class CarritoCargado extends CarritoState {
  final List<Plato> platos;

  CarritoCargado(this.platos);
}

class CarritoActualizado extends CarritoState {
  final List<CarritoItem> items;

  CarritoActualizado(this.items);
}
