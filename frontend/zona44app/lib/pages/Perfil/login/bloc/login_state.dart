part of 'login_bloc.dart';

final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {
  final int userId;
  final String token;
  const LoginSuccess({required this.userId, required this.token});

  @override
  List<Object> get props => [userId, token];
}
final class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}

sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}
