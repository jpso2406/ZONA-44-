import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:zona44app/models/order.dart';
part 'order_admin_event.dart';
part 'order_admin_state.dart';

class OrderAdminBloc extends Bloc<OrderAdminEvent, OrderAdminState> {
  final UserService userService;
  OrderAdminBloc({required this.userService}) : super(OrderAdminInitial()) {
    on<LoadAdminOrders>(_onLoadAdminOrders);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onLoadAdminOrders(
    LoadAdminOrders event,
    Emitter<OrderAdminState> emit,
  ) async {
    emit(OrderAdminLoading());
    try {
      final orders = await userService.getAdminOrders(event.token);
      emit(OrderAdminSuccessState(orders));
    } catch (e) {
      emit(OrderAdminFailureState(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderAdminState> emit,
  ) async {
    emit(OrderAdminLoading());
    try {
      final updatedOrder = await userService.updateOrderStatus(
        event.token,
        event.orderId,
        event.newStatus,
      );
      emit(OrderAdminStatusUpdated(updatedOrder));
    } catch (e) {
      emit(OrderAdminFailureState(e.toString()));
    }
  }
}
