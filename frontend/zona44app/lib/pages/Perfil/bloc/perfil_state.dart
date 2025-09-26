part of 'perfil_bloc.dart';

sealed class PerfilState extends Equatable {
  const PerfilState();
  
  @override
  List<Object> get props => [];
}

final class PerfilLoadingState extends PerfilState {}

final class PerfilSuccessState extends PerfilState {}

final class PerfilFailureState extends PerfilState {}
