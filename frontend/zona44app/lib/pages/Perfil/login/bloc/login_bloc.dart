import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:zona44app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;
  LoginBloc({required this.userService}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final res = await userService.loginUser(event.email, event.password);
      // Guardar el role en SharedPreferences si viene en la respuesta
      if (res.containsKey('role')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', res['role']);
      }
      emit(LoginSuccess(userId: res['user_id'], token: res['token']));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
