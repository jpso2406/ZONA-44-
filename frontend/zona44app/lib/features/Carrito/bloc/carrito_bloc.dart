import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zona44app/exports/exports.dart';

part 'carrito_event.dart';
part 'carrito_state.dart';

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  CarritoBloc() : super(const CarritoLoaded([])) {
    on<AgregarProducto>(_onAgregarProducto);
    on<RemoverProducto>(_onRemoverProducto);
    on<ActualizarCantidad>(_onActualizarCantidad);
    on<LimpiarCarrito>(_onLimpiarCarrito);
  }

  void _onAgregarProducto(AgregarProducto event, Emitter<CarritoState> emit) {
    final current = state is CarritoLoaded ? (state as CarritoLoaded).items : <CarritoItem>[];
    final items = List<CarritoItem>.from(current);
    final i = items.indexWhere((it) => it.producto.id == event.producto.id);
    if (i >= 0) {
      items[i] = items[i].copyWith(cantidad: items[i].cantidad + 1);
    } else {
      items.add(CarritoItem(producto: event.producto));
    }
    emit(CarritoLoaded(items));
  }

  void _onRemoverProducto(RemoverProducto event, Emitter<CarritoState> emit) {
    final current = (state as CarritoLoaded).items;
    final items = List<CarritoItem>.from(current)..removeWhere((it) => it.producto.id == event.productoId);
    emit(CarritoLoaded(items));
  }

  void _onActualizarCantidad(ActualizarCantidad event, Emitter<CarritoState> emit) {
    final current = (state as CarritoLoaded).items;
    final items = List<CarritoItem>.from(current);
    final i = items.indexWhere((it) => it.producto.id == event.productoId);
    if (i >= 0) {
      if (event.cantidad <= 0) {
        items.removeAt(i);
      } else {
        items[i] = items[i].copyWith(cantidad: event.cantidad);
      }
      emit(CarritoLoaded(items));
    }
  }

  void _onLimpiarCarrito(LimpiarCarrito event, Emitter<CarritoState> emit) {
    emit(const CarritoLoaded([]));
  }
}