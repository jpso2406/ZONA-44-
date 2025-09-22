part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class GruposLoaded extends MenuState {
  final List<Grupo> grupos;

  const GruposLoaded(this.grupos);

  @override
  List<Object> get props => [grupos];
}

class ProductosLoaded extends MenuState {
  final Grupo grupo;
  final List<Producto> productos;

  const ProductosLoaded(this.grupo, this.productos);

  @override
  List<Object> get props => [grupo, productos];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object> get props => [message];
}
