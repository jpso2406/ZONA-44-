part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class NavigateToInicio extends HomeEvent {}

class NavigateToCarrito extends HomeEvent {}

class NavigateToPerfil extends HomeEvent {}

class NavigateToMenu extends HomeEvent {}
