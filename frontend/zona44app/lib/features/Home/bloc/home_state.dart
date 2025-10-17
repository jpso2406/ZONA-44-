part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

class HomeNavigating extends HomeState {
  final String destination;

  const HomeNavigating(this.destination);

  @override
  List<Object> get props => [destination];
}
