import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../models/order.dart';
import '../bloc/orders_bloc.dart';
import 'order_failure.dart';
import 'order_loading.dart';
import '../../../../../services/order_service.dart';
import '../../../../../features/Carrito/widgets/payment_form_dialog.dart';
import '../../../../../features/Carrito/widgets/payment_result_dialog.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const OrderLoading();
        } else if (state is OrdersFailure) {
          return OrderFailure(
            onRetry: () {
              context.read<OrdersBloc>().add(OrdersRequested());
            },
          );
        } else if (state is OrdersSuccess) {
          final orders = state.orders;
          if (orders.isEmpty) {
            return Center(
              child: Text(
                'No tienes órdenes aún',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderCard(order: order);
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orden #${order.id}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  order.createdAt != null
                      ? _formatDate(order.createdAt!)
                      : 'Fecha desconocida',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Total: S/ ${order.totalAmount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estado: ${_getStatusDisplayName(order.status)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (order.status.toLowerCase() == 'pending')
                  ElevatedButton.icon(
                    onPressed: () => _handlePayment(context, order),
                    icon: const Icon(Icons.payment, size: 16),
                    label: const Text('Pagar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 131, 7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Productos:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            ...order.orderItems.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.producto.name,
                        style: GoogleFonts.poppins(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  // Formato: dd/MM/yyyy
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _getStatusDisplayName(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Pendiente';
    case 'processing':
      return 'En proceso';
    case 'paid':
      return 'Pagado';
    case 'failed':
      return 'Fallido';
    case 'cancelled':
      return 'Cancelado';
    default:
      return status.isEmpty ? 'Pendiente' : status;
  }
}

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Colors.orange;
    case 'processing':
      return Colors.blue;
    case 'paid':
      return Colors.green;
    case 'failed':
      return Colors.red;
    case 'cancelled':
      return Colors.grey;
    default:
      return status.isEmpty ? Colors.orange : Colors.blueAccent;
  }
}

Future<void> _handlePayment(BuildContext context, Order order) async {
  try {
    // Mostrar formulario de pago
    final cardData = await const PaymentFormDialog().show(context);

    if (cardData != null) {
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

      try {
        // Procesar pago
        final payResp = await const OrderService().payOrder(
          orderId: order.id,
          cardNumber: cardData['number'] ?? '',
          cardExpiration: cardData['exp'] ?? '',
          cardCvv: cardData['cvv'] ?? '',
          cardName: cardData['name'] ?? '',
        );

        // Cerrar loading
        Navigator.of(context, rootNavigator: true).pop();

        if (payResp['success'] == true) {
          // Mostrar resultado exitoso
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const PaymentResultDialog(success: true),
          );

          // Recargar la lista de órdenes para mostrar el estado actualizado
          if (context.mounted) {
            context.read<OrdersBloc>().add(OrdersRequested());
          }
        } else {
          // Mostrar error de pago
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => PaymentResultDialog(
              success: false,
              message: 'Pago rechazado: ${payResp['error'] ?? ''}',
            ),
          );
        }
      } catch (e) {
        // Cerrar loading si hay error
        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        // Mostrar error
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => PaymentResultDialog(
            success: false,
            message: 'Error procesando pago: $e',
          ),
        );
      }
    }
  } catch (e) {
    // Mostrar error general
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentResultDialog(
        success: false,
        message: 'Error iniciando pago: $e',
      ),
    );
  }
}
