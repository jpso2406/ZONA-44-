import 'package:flutter/material.dart';
import 'package:zona44app/models/order.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/order_details.dart';

/// Vista que muestra la lista de órdenes para el admin
/// Permite ver detalles de cada orden al tocarla
/// Usada en OrderAdminPage cuando el estado es OrderAdminSuccessState
class OrderAdminSuccess extends StatelessWidget {
  final List<Order> orders;
  final void Function(int orderId, String newStatus) onUpdateStatus;
  const OrderAdminSuccess({
    super.key,
    required this.orders,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No hay pedidos para mostrar.',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          title: Text(
            'Pedido #${order.orderNumber}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'Estado: ${_getStatusDisplayName(order.status)}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _getStatusColor(order.status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 18,
          ),
          tileColor: const Color.fromARGB(80, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  OrderDetails(order: order, onUpdateStatus: onUpdateStatus),
            );
          },
        );
      },
    );
  }
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
      return status.isEmpty ? Colors.orange : Colors.orangeAccent;
  }
}
