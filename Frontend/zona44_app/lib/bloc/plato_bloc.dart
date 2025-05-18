import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/plato_repository.dart';
import 'plato_event.dart';
import 'plato_state.dart';
class PlatoBloc extends Bloc<PlatoEvent, PlatoState> {
  final PlatoRepository repository;

  PlatoBloc(this.repository) : super(PlatoInicial()) {
    on<CargarPlatos>((event, emit) async {
      emit(PlatoCargando());
      try {
        final platos = await repository.obtenerPlatos();
        emit(PlatoCargado(platos));
      } catch (e) {
        emit(PlatoError('No se pudieron cargar los platos.'));
      }
    });
  }
}