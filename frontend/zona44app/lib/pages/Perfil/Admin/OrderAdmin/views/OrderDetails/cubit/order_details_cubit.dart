import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit() : super(OrderDetailsInitial());
}
