import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:zona44app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  PerfilBloc() : super(PerfilLoadingState()) {
    on<PerfilLoadRequested>(_onPerfilLoadRequested);
  }

  Future<void> _onPerfilLoadRequested(
    PerfilLoadRequested event,
    Emitter<PerfilState> emit,
  ) async {
    emit(PerfilLoadingState());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        emit(PerfilFailureState('No autenticado'));
        return;
      }
      final user = await UserService().getProfile(token);
      emit(PerfilSuccessState(user));
    } catch (e) {
      emit(PerfilFailureState('Error cargando perfil'));
    }
  }
}
