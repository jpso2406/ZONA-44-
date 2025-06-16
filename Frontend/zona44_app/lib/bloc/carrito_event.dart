import '../models/plato.dart';

abstract class CarritoEvent {}

class AgregarAlCarrito extends CarritoEvent {
  final Plato plato;

  AgregarAlCarrito(this.plato);
}

class RemoverDelCarrito extends CarritoEvent {
  final Plato plato;

  RemoverDelCarrito(this.plato);
}

class VaciarCarrito extends CarritoEvent {}
