import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/bloc/order_admin_bloc.dart';
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/views/orderAdminLoading.dart' as views;
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/views/orderAdminFailure.dart';
import 'package:zona44app/pages/Perfil/Admin/OrderAdmin/views/orderAdminsuccess.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderAdminPage extends StatefulWidget {
  const OrderAdminPage({Key? key}) : super(key: key);

  @override
  State<OrderAdminPage> createState() => _OrderAdminPageState();
}

class _OrderAdminPageState extends State<OrderAdminPage> {
  late OrderAdminBloc _bloc;
  String? _token;

  @override
  void initState() {
    super.initState();
    _bloc = OrderAdminBloc(userService: UserService());
    _loadTokenAndOrders();
  }

  Future<void> _loadTokenAndOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() => _token = token);
    if (token != null) {
      _bloc.add(LoadAdminOrders(token));
    }
  }

  void _onUpdateStatus(int orderId, String newStatus) {
    if (_token != null) {
      _bloc.add(
        UpdateOrderStatusEvent(
          token: _token!,
          orderId: orderId,
          newStatus: newStatus,
        ),
      );
      // Recargar lista después de actualizar
      Future.delayed(const Duration(milliseconds: 500), () {
        _bloc.add(LoadAdminOrders(_token!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Pedidos (Admin)')),
        body: BlocBuilder<OrderAdminBloc, OrderAdminState>(
          builder: (context, state) {
            if (state is OrderAdminLoading) {
              return const views.OrderAdminLoading();
            } else if (state is OrderAdminFailureState) {
              return OrderAdminFailure(message: state.message);
            } else if (state is OrderAdminSuccessState) {
              return OrderAdminSuccess(
                orders: state.orders,
                onUpdateStatus: _onUpdateStatus,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
