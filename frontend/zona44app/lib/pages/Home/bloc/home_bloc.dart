import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<NavigateToInicio>((event, emit) {
      emit(HomeNavigating('inicio'));
    });

    on<NavigateToCarrito>((event, emit) {
      emit(HomeNavigating('carrito'));
    });

    on<NavigateToPerfil>((event, emit) {
      emit(HomeNavigating('perfil'));
    });
  }
}
