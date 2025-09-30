
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

  Future<void> _onRegisterSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
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
      emit(RegisterFailure(e.toString()));
    }
  }
}
