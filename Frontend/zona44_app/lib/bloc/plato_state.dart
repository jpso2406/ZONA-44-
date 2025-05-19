import 'package:equatable/equatable.dart';
import '../models/plato.dart';

abstract class PlatoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlatoInicial extends PlatoState {}

class PlatoCargando extends PlatoState {}

class PlatoCargado extends PlatoState {
  final List<Plato> platos;

  PlatoCargado(this.platos);

  @override
  List<Object?> get props => [platos];
}

class PlatoError extends PlatoState {
  final String mensaje;

  PlatoError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
