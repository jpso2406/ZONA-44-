part of 'order_admin_bloc.dart';

sealed class OrderAdminEvent extends Equatable {
  const OrderAdminEvent();

  @override
  List<Object> get props => [];
}

class LoadAdminOrders extends OrderAdminEvent {
  final String token;
  const LoadAdminOrders(this.token);

  @override
  List<Object> get props => [token];
}

class UpdateOrderStatusEvent extends OrderAdminEvent {
  final String token;
  final int orderId;
  final String newStatus;
  const UpdateOrderStatusEvent({required this.token, required this.orderId, required this.newStatus});

  @override
  List<Object> get props => [token, orderId, newStatus];
}
