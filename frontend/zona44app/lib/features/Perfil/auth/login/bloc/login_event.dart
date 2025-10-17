part of 'login_bloc.dart';

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class GoogleLoginSubmitted extends LoginEvent {
  const GoogleLoginSubmitted();

  @override
  List<Object> get props => [];
}

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}
