import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  PerfilBloc() : super(PerfilLoadingState()) {
    on<PerfilEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
