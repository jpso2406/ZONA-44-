import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zona44app/models/order.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final UserService userService;
  OrdersBloc({required this.userService}) : super(OrdersLoading()) {
    on<OrdersRequested>(_onOrdersRequested);
  }

  Future<void> _onOrdersRequested(
    OrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        emit(OrdersFailure('No autenticado'));
        return;
      }
      final orders = await userService.getUserOrders(token);
      emit(OrdersSuccess(orders));
    } catch (e) {
      emit(OrdersFailure('Error al cargar el historial de órdenes'));
    }
  }
}
