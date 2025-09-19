// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/carrito_bloc.dart';
import 'package:zona44app/exports/exports.dart';

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
              return const Center(
                child: Text(
                  'Tu carrito está vacío',
                  style: TextStyle(color: Colors.white),
                ),
              );
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

      final resp = await const OrderService().createOrder(
        cart: cartPayload,
        totalAmount: state.totalPrecio,
        customer: customer,
      );
      if (resp['success'] == true) {
        final orderId = resp['order_id'];
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Orden #$orderId creada')));
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
            );

            if (payResp['success'] == true) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Pago aprobado')));
              // Vaciar carrito tras pago exitoso
              // ignore:
              context.read<CarritoBloc>().add(LimpiarCarrito());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pago rechazado: ${payResp['error'] ?? ''}'),
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error procesando pago: $e')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${resp['errors'] ?? 'No se pudo crear la orden'}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error creando la orden: $e')));
    }
  }
}
