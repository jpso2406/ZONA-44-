import 'package:equatable/equatable.dart';
import '../models/plato.dart';

abstract class PlatoState extends Equatable {
  const PlatoState();

  @override
  List<Object> get props => [];
}

class PlatoInicial extends PlatoState {}

class PlatoCargando extends PlatoState {}

class PlatoCargado extends PlatoState {
  final List<Plato> platos;

  const PlatoCargado(this.platos);

  @override
  List<Object> get props => [platos];
}

class PlatoError extends PlatoState {
  final String mensaje;

  const PlatoError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}
