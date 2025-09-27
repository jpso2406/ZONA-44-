part of 'perfil_bloc.dart';

sealed class PerfilEvent extends Equatable {
  const PerfilEvent();

  @override
  List<Object> get props => [];
}

class PerfilLoadRequested extends PerfilEvent {}
