import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zona44app/exports/exports.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuService _menuService = MenuService();
  List<Grupo>? _gruposCache; // Cache para mantener los grupos

  MenuBloc() : super(MenuInitial()) {
    on<LoadMenu>(_onLoadMenu);
    on<SelectGrupo>(_onSelectGrupo);
    on<GoBackToGrupos>(_onGoBackToGrupos);
  }

  Future<void> _onLoadMenu(LoadMenu event, Emitter<MenuState> emit) async {
    // Solo hacer petición si no tenemos grupos en cache
    if (_gruposCache != null) {
      emit(GruposLoaded(_gruposCache!));
      return;
    }

    emit(MenuLoading());

    try {
      final grupos = await _menuService.getGrupos();
      _gruposCache = grupos; // Guardar en cache
      emit(GruposLoaded(grupos));
    } catch (e) {
      emit(MenuError(e.toString()));
    }
  }

  void _onSelectGrupo(SelectGrupo event, Emitter<MenuState> emit) {
    List<Grupo> gruposDisponibles = [];

    if (state is GruposLoaded) {
      final gruposState = state as GruposLoaded;
      gruposDisponibles = gruposState.grupos;
      final grupo = gruposDisponibles.firstWhere(
        (g) => g.slug == event.grupoSlug,
      );
      emit(ProductosLoaded(grupo, grupo.productos, gruposDisponibles));
    } else if (state is ProductosLoaded) {
      // Si ya estamos en productos, solo cambiar de grupo
      final productosState = state as ProductosLoaded;
      gruposDisponibles = productosState.todosLosGrupos;
      final grupo = gruposDisponibles.firstWhere(
        (g) => g.slug == event.grupoSlug,
      );
      emit(ProductosLoaded(grupo, grupo.productos, gruposDisponibles));
    } else if (_gruposCache != null) {
      // Fallback: usar cache si existe
      gruposDisponibles = _gruposCache!;
      final grupo = gruposDisponibles.firstWhere(
        (g) => g.slug == event.grupoSlug,
      );
      emit(ProductosLoaded(grupo, grupo.productos, gruposDisponibles));
    }
  }

  void _onGoBackToGrupos(GoBackToGrupos event, Emitter<MenuState> emit) {
    // Simplemente volver a emitir el estado de grupos desde el cache
    if (_gruposCache != null) {
      emit(GruposLoaded(_gruposCache!));
    }
  }

  // Método para limpiar cache si es necesario (por ejemplo, en pull-to-refresh)
  void clearCache() {
    _gruposCache = null;
  }
}
