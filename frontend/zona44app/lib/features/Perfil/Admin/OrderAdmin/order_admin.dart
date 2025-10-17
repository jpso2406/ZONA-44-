import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/features/Perfil/Admin/OrderAdmin/bloc/order_admin_bloc.dart';
import 'package:zona44app/features/Perfil/Admin/OrderAdmin/views/order_admin_loading.dart'
    as views;
import 'package:zona44app/features/Perfil/Admin/OrderAdmin/views/order_admin_failure.dart';  
import 'package:zona44app/features/Perfil/Admin/OrderAdmin/views/order_admin_success.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Página para que el admin vea y gestione todas las órdenes
/// Usa un Bloc llamado OrderAdminBloc para manejar el estado de las órdenes
class OrderAdminPage extends StatelessWidget {
  const OrderAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: SharedPreferences.getInstance().then(
        (prefs) => prefs.getString('token'),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const views.OrderAdminLoading();
        }
        final token = snapshot.data;
        if (token == null) {
          return OrderAdminFailure(message: 'No autenticado');
        }
        return BlocProvider(
          create: (context) {
            final bloc = OrderAdminBloc(userService: UserService());
            bloc.add(LoadAdminOrders(token));
            return bloc;
          },
          child: BlocBuilder<OrderAdminBloc, OrderAdminState>(
            builder: (context, state) {
              void onUpdateStatus(int orderId, String newStatus) {
                // Dispara el evento de actualización de estado (muestra loading)
                BlocProvider.of<OrderAdminBloc>(context).add(
                  UpdateOrderStatusEvent(
                    token: token,
                    orderId: orderId,
                    newStatus: newStatus,
                  ),
                );
              }

              if (state is OrderAdminLoading) {
                return const views.OrderAdminLoading();
              } else if (state is OrderAdminFailureState) {
                return OrderAdminFailure(message: state.message);
              } else if (state is OrderAdminStatusUpdated) {
                // Cuando se actualizó el estado, recarga la lista
                BlocProvider.of<OrderAdminBloc>(
                  context,
                ).add(LoadAdminOrders(token));
                return const views.OrderAdminLoading();
              } else if (state is OrderAdminSuccessState) {
                return OrderAdminSuccess(
                  orders: state.orders,
                  onUpdateStatus: onUpdateStatus,
                );
              } else {
                return const views.OrderAdminLoading();
              }
            },
          ),
        );
      },
    );
  }
}
