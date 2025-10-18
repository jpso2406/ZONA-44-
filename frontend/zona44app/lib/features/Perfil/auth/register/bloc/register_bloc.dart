import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zona44app/models/user.dart';
import 'package:zona44app/services/user_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserService userService;
  RegisterBloc({required this.userService}) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final user = User(
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        phone: event.phone,
        address: event.address,
        city: event.city,
        department: event.department,
      );
      await userService.registerUser(user, event.password);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(_getUserFriendlyErrorMessage(e.toString())));
    }
  }

  /// Convierte errores técnicos en mensajes amigables para el usuario
  String _getUserFriendlyErrorMessage(String error) {
    // Errores de email ya registrado
    if (error.contains('email') &&
        (error.contains('already') || error.contains('ya está'))) {
      return 'email_already_exists';
    }

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
    return 'register_error';
  }
}
