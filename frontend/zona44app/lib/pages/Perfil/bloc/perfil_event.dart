part of 'perfil_bloc.dart';

sealed class PerfilEvent extends Equatable {
  const PerfilEvent();

  @override
  List<Object> get props => [];
}

class PerfilLogin extends PerfilEvent {
  final String email;
  final String password;

  PerfilLogin(this.email, this.password);
}
