part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object> get props => [];
}

class RequestPasswordReset extends ForgotPasswordEvent {
  final String email;

  const RequestPasswordReset(this.email);

  @override
  List<Object> get props => [email];
}

class VerifyResetCode extends ForgotPasswordEvent {
  final String email;
  final String code;

  const VerifyResetCode(this.email, this.code);

  @override
  List<Object> get props => [email, code];
}

class ResetPassword extends ForgotPasswordEvent {
  final String email;
  final String code;
  final String newPassword;

  const ResetPassword(this.email, this.code, this.newPassword);

  @override
  List<Object> get props => [email, code, newPassword];
}

class ResetForgotPasswordState extends ForgotPasswordEvent {
  const ResetForgotPasswordState();
}
