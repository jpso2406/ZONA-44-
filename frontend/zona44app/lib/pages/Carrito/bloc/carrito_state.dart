part of 'carrito_bloc.dart';

sealed class CarritoState extends Equatable {
  const CarritoState();
  
  @override
  List<Object> get props => [];
}

final class CarritoInitial extends CarritoState {}
