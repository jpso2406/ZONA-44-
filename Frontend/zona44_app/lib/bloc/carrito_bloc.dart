import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/carrito_item.dart';
import 'carrito_event.dart';
import 'carrito_state.dart';

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  final List<CarritoItem> _items = [];

  CarritoBloc() : super(CarritoInicial()) {
    on<AgregarAlCarrito>((event, emit) {
      final index = _items.indexWhere((item) => item.plato.id == event.plato.id);
      if (index >= 0) {
        _items[index] = CarritoItem(
          plato: _items[index].plato,
          cantidad: _items[index].cantidad + 1,
        );
      } else {
        _items.add(CarritoItem(plato: event.plato, cantidad: 1));
      }
      emit(CarritoActualizado(List.from(_items)));
    });

    on<RemoverDelCarrito>((event, emit) {
      _items.removeWhere((item) => item.plato.id == event.plato.id);
      emit(CarritoActualizado(List.from(_items)));
    });

    on<VaciarCarrito>((event, emit) {
      _items.clear();
      emit(CarritoActualizado(List.from(_items)));
    });
  }
}
