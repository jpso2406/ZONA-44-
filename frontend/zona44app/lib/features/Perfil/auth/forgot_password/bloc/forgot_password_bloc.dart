import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zona44app/services/user_service.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final UserService userService;

  ForgotPasswordBloc({required this.userService})
    : super(ForgotPasswordInitial()) {
    on<RequestPasswordReset>(_onRequestPasswordReset);
    on<VerifyResetCode>(_onVerifyResetCode);
    on<ResetPassword>(_onResetPassword);
    on<ResetForgotPasswordState>(_onResetForgotPasswordState);
  }

  Future<void> _onRequestPasswordReset(
    RequestPasswordReset event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final result = await userService.requestPasswordReset(event.email);
      if (result['success'] == true) {
        emit(ForgotPasswordStep1Success(result['message'], event.email));
      } else {
        emit(ForgotPasswordFailure(result['message']));
      }
    } catch (e) {
      emit(ForgotPasswordFailure('Error inesperado: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyResetCode(
    VerifyResetCode event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final result = await userService.verifyResetCode(event.email, event.code);
      if (result['success'] == true) {
        emit(
          ForgotPasswordStep2Success(
            result['message'],
            event.email,
            event.code,
          ),
        );
      } else {
        emit(ForgotPasswordFailure(result['message']));
      }
    } catch (e) {
      emit(ForgotPasswordFailure('Error inesperado: ${e.toString()}'));
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final result = await userService.resetPassword(
        event.email,
        event.code,
        event.newPassword,
      );
      if (result['success'] == true) {
        emit(ForgotPasswordStep3Success(result['message']));
      } else {
        emit(ForgotPasswordFailure(result['message']));
      }
    } catch (e) {
      emit(ForgotPasswordFailure('Error inesperado: ${e.toString()}'));
    }
  }

  void _onResetForgotPasswordState(
    ResetForgotPasswordState event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(ForgotPasswordInitial());
  }
}
