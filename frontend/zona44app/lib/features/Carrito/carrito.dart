// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/carrito_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/services/user_service.dart';

class Carrito extends StatelessWidget {
  const Carrito({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 670,
        decoration: BoxDecoration(
          color: const Color.fromARGB(240, 4, 14, 63),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: BlocBuilder<CarritoBloc, CarritoState>(
          builder: (context, state) {
            if (state is! CarritoLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (state.items.isEmpty) {
              return CartEmpty();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => CartItemCard(
                      producto: state.items[index].producto,
                      cantidad: state.items[index].cantidad,
                      item: state.items[index],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CartSummary(
                    total: state.totalPrecio.toDouble(),
                    onCheckout: () => _handleCheckout(context, state),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleCheckout(
    BuildContext context,
    CarritoLoaded state,
  ) async {
    final cartPayload = state.items
        .map(
          (it) => {
            'producto_id': it.producto.id,
            'cantidad': it.cantidad,
            'unit_price': it.producto.precio,
          },
        )
        .toList();

    try {
      // Datos del cliente (opcional)
      final customer = await const CustomerFormDialog().show(context);
      if (customer == null) {
        // El usuario cerró el formulario, no hacer la petición
        return;
      }

      // Separar delivery_type del resto de los datos del cliente
      final deliveryType = customer['delivery_type'] ?? 'domicilio';
      final customerData = Map<String, dynamic>.from(customer);
      customerData.remove('delivery_type');

      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 239, 131, 7),
          ),
        ),
      );

      // Obtener token de autenticación
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');

      // Obtener user_id si está autenticado
      int? userId;
      if (authToken != null && authToken.isNotEmpty) {
        try {
          final user = await UserService().getProfile(authToken);
          userId = user.id;
        } catch (e) {
          print('Error obteniendo perfil del usuario: $e');
        }
      }

      final resp = await const OrderService().createOrder(
        cart: cartPayload,
        totalAmount: state.totalPrecio,
        customer: customerData,
        deliveryType: deliveryType,
        authToken: authToken,
        userId: userId, // ⚠️ CRÍTICO: Incluir user_id
      );
      // Cerrar loading
      Navigator.of(context, rootNavigator: true).pop();
      if (resp['success'] == true) {
        final orderId = resp['order_id'];
        // Quitar mensaje de orden creada
        // Solicitar datos de tarjeta sandbox y pagar
        final cardData = await const PaymentFormDialog().show(context);

        if (cardData != null) {
          try {
            final payResp = await const OrderService().payOrder(
              orderId: orderId,
              cardNumber: cardData['number'] ?? '',
              cardExpiration: cardData['exp'] ?? '',
              cardCvv: cardData['cvv'] ?? '',
              cardName: cardData['name'] ?? '',
              authToken: authToken,
            );

            if (payResp['success'] == true) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const PaymentResultDialog(success: true),
              );
              // Vaciar carrito tras pago exitoso
              context.read<CarritoBloc>().add(LimpiarCarrito());
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => PaymentResultDialog(
                  success: false,
                  message: 'Pago rechazado: \\${payResp['error'] ?? ''}',
                ),
              );
            }
          } catch (e) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => PaymentResultDialog(
                success: false,
                message: 'Error procesando pago: \\${e}',
              ),
            );
          }
        }
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => PaymentResultDialog(
            success: false,
            message: 'Error creando la orden: \\${resp['error'] ?? ''}',
          ),
        );
      }
    } catch (e) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PaymentResultDialog(
          success: false,
          message: 'Error creando la orden: \\${e}',
        ),
      );
    }
  }
}
