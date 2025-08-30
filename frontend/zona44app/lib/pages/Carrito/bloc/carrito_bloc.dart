import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/carrito_item.dart';
import '../../../models/producto.dart';

part 'carrito_event.dart';
part 'carrito_state.dart';

class CarritoBloc extends Bloc<CarritoEvent, CarritoState> {
  CarritoBloc() : super(CarritoInitial()) {
    on<AgregarProducto>(_onAgregarProducto);
    on<RemoverProducto>(_onRemoverProducto);
    on<ActualizarCantidad>(_onActualizarCantidad);
    on<LimpiarCarrito>(_onLimpiarCarrito);
  }

  void _onAgregarProducto(AgregarProducto event, Emitter<CarritoState> emit) {
    final currentItems = List<CarritoItem>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (item) => item.producto.id == event.producto.id,
    );

    if (existingIndex >= 0) {
      // Si ya existe, aumentar cantidad
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        cantidad: currentItems[existingIndex].cantidad + 1,
      );
    } else {
      // Si no existe, agregar nuevo
      currentItems.add(CarritoItem(producto: event.producto));
    }

    emit(CarritoLoaded(currentItems));
  }

  void _onRemoverProducto(RemoverProducto event, Emitter<CarritoState> emit) {
    final currentItems = List<CarritoItem>.from(state.items);
    currentItems.removeWhere((item) => item.producto.id == event.productoId);
    emit(CarritoLoaded(currentItems));
  }

  void _onActualizarCantidad(ActualizarCantidad event, Emitter<CarritoState> emit) {
    final currentItems = List<CarritoItem>.from(state.items);
    final index = currentItems.indexWhere(
      (item) => item.producto.id == event.productoId,
    );

    if (index >= 0) {
      if (event.cantidad <= 0) {
        currentItems.removeAt(index);
      } else {
        currentItems[index] = currentItems[index].copyWith(
          cantidad: event.cantidad,
        );
      }
      emit(CarritoLoaded(currentItems));
    }
  }

  void _onLimpiarCarrito(LimpiarCarrito event, Emitter<CarritoState> emit) {
    emit(CarritoLoaded([]));
  }
}