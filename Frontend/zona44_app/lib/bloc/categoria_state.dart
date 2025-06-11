import 'package:equatable/equatable.dart';
import '../models/categoria.dart';

abstract class CategoriaState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoriaInicial extends CategoriaState {}

class CategoriaCargando extends CategoriaState {}

class CategoriaCargado extends CategoriaState { // ¡Este es el nombre correcto!
  final List<Categoria> categorias;

  CategoriaCargado(this.categorias);

  @override
  List<Object?> get props => [categorias];
}

class CategoriaError extends CategoriaState {
  final String mensaje;

  CategoriaError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
