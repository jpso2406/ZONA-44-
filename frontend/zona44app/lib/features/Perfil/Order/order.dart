import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Order/bloc/orders_bloc.dart';
import '../Order/views/order_success.dart';
import '../../../services/user_service.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = OrdersBloc(userService: UserService());
        bloc.add(OrdersRequested());
        return bloc;
      },
      child: const OrderSuccess(),
    );
  }
}
