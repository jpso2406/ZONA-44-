import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/bloc/order_admin_bloc.dart';
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/views/orderAdminLoading.dart'
    as views;
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/views/orderAdminFailure.dart';
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/views/orderAdminsuccess.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderAdminPage extends StatelessWidget {
  const OrderAdminPage({Key? key}) : super(key: key);

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
                BlocProvider.of<OrderAdminBloc>(context).add(
                  UpdateOrderStatusEvent(
                      token: token,
                      orderId: orderId,
                      newStatus: newStatus,
                    ),
                  );
                  // Recargar lista después de actualizar
                  Future.delayed(const Duration(milliseconds: 500), () {
                    BlocProvider.of<OrderAdminBloc>(
                      context,
                    ).add(LoadAdminOrders(token));
                  });
                }

                if (state is OrderAdminLoading) {
                  return const views.OrderAdminLoading();
                } else if (state is OrderAdminFailureState) {
                  return OrderAdminFailure(message: state.message);
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
