import 'package:equatable/equatable.dart';

abstract class PlatoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CargarPlatos extends PlatoEvent {}