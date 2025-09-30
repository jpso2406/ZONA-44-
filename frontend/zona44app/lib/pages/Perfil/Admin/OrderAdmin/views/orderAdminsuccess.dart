import 'package:flutter/material.dart';
import 'package:zona44app/models/order.dart';
import 'package:google_fonts/google_fonts.dart';

import 'OrderDetails/order_details.dart';

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
              'Estado: ${order.status}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.orangeAccent,
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
              builder: (context) => OrderDetails(order: order),
            );
          },
        );
      },
    );
  }

}
    