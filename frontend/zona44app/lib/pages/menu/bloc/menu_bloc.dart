import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/producto.dart';
import '../../../services/menu_service.dart';
import '../../../models/grupo.dart';

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
    if (state is GruposLoaded) {
      final gruposState = state as GruposLoaded;
      final grupo = gruposState.grupos.firstWhere(
        (g) => g.slug == event.grupoSlug,
      );
      emit(ProductosLoaded(grupo, grupo.productos));
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