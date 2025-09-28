part of 'order_admin_bloc.dart';

sealed class OrderAdminState extends Equatable {
  const OrderAdminState();
  @override
  List<Object> get props => [];
}

final class OrderAdminInitial extends OrderAdminState {}

final class OrderAdminLoading extends OrderAdminState {}

final class OrderAdminFailureState extends OrderAdminState {
  final String message;
  const OrderAdminFailureState(this.message);
  @override
  List<Object> get props => [message];
}

final class OrderAdminSuccessState extends OrderAdminState {
  final List<Order> orders;
  const OrderAdminSuccessState(this.orders);
  @override
  List<Object> get props => [orders];
}

final class OrderAdminStatusUpdated extends OrderAdminState {
  final Order updatedOrder;
  const OrderAdminStatusUpdated(this.updatedOrder);
  @override
  List<Object> get props => [updatedOrder];
}
