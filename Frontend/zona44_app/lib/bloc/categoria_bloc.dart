import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/categoria_repository.dart';
import 'categoria_event.dart';
import 'categoria_state.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository repository;

  CategoriaBloc(this.repository) : super(CategoriaInicial()) {
    on<CargarCategorias>((event, emit) async {
      emit(CategoriaCargando());
      try {
        final categorias = await repository.obtenerCategorias();
        emit(CategoriaCargado(categorias)); // Este estado debe existir (revisado)
      } catch (_) {
        emit(CategoriaError('No se pudieron cargar las categorías.'));
      }
    });
  }
}
