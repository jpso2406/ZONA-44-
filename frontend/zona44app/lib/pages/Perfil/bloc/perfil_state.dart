part of 'perfil_bloc.dart';

sealed class PerfilState extends Equatable {
  const PerfilState();
  @override
  List<Object?> get props => [];
}

final class PerfilLoadingState extends PerfilState {}

final class PerfilSuccessState extends PerfilState {
  final User user;
  const PerfilSuccessState(this.user);
  @override
  List<Object?> get props => [user];
}

final class PerfilFailureState extends PerfilState {
  final String message;
  const PerfilFailureState(this.message);
  @override
  List<Object?> get props => [message];
}
