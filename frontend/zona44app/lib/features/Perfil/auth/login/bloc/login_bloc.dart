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
    on<GoogleLoginSubmitted>(_onGoogleLoginSubmitted);
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
      emit(LoginFailure(_getUserFriendlyErrorMessage(e.toString())));
    }
  }

  Future<void> _onGoogleLoginSubmitted(
    GoogleLoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final res = await userService.loginWithGoogle();

      // Verificar si el usuario canceló el inicio de sesión
      if (res['cancelled'] == true) {
        // No mostrar error, simplemente volver al estado inicial
        emit(LoginInitial());
        return;
      }

      emit(LoginSuccess(userId: res['user_id'], token: res['token']));
    } catch (e) {
      emit(LoginFailure(_getUserFriendlyErrorMessage(e.toString())));
    }
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _getUserFriendlyErrorMessage(String error) {
    // Errores de credenciales inválidas
    if (error.contains('Credenciales inválidas') ||
        error.contains('401') ||
        error.contains('unauthorized')) {
      return 'invalid_credentials';
    }

    // Errores de red/conexión
    if (error.contains('SocketException') ||
        error.contains('NetworkException') ||
        error.contains('timeout') ||
        error.contains('connection')) {
      return 'network_error';
    }

    // Errores del servidor
    if (error.contains('500') ||
        error.contains('502') ||
        error.contains('503') ||
        error.contains('504')) {
      return 'server_error';
    }

    // Error genérico
    return 'login_error';
  }
}
