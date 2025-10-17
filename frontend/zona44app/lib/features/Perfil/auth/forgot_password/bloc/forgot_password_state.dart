part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordStep1Success extends ForgotPasswordState {
  final String message;
  final String email;

  const ForgotPasswordStep1Success(this.message, this.email);

  @override
  List<Object> get props => [message, email];
}

class ForgotPasswordStep2Success extends ForgotPasswordState {
  final String message;
  final String email;
  final String code;

  const ForgotPasswordStep2Success(this.message, this.email, this.code);

  @override
  List<Object> get props => [message, email, code];
}

class ForgotPasswordStep3Success extends ForgotPasswordState {
  final String message;

  const ForgotPasswordStep3Success(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String error;

  const ForgotPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}
