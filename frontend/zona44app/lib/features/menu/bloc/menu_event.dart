part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class LoadMenu extends MenuEvent {}

class SelectGrupo extends MenuEvent {
  final String grupoSlug;
  
  const SelectGrupo(this.grupoSlug);
  
  @override
  List<Object> get props => [grupoSlug];
}

class GoBackToGrupos extends MenuEvent {}
