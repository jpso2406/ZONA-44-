import 'package:flutter/material.dart';
import 'package:zona44app/models/order.dart';

class OrderAdminSuccess extends StatelessWidget {
  final List<Order> orders;
  final void Function(int orderId, String newStatus) onUpdateStatus;
  const OrderAdminSuccess({
    Key? key,
    required this.orders,
    required this.onUpdateStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text('No hay pedidos para mostrar.'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Pedido #${order.orderNumber}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado: ${order.status}'),
                Text('Total: S/ ${order.totalAmount.toStringAsFixed(2)}'),
                Text(
                  'Fecha: ${order.createdAt != null ? order.createdAt.toString() : 'N/A'}',
                ),
                // Aquí puedes mostrar más detalles si lo deseas
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => onUpdateStatus(order.id, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'pendiente',
                  child: Text('Pendiente'),
                ),
                const PopupMenuItem(
                  value: 'en_proceso',
                  child: Text('En proceso'),
                ),
                const PopupMenuItem(
                  value: 'entregado',
                  child: Text('Entregado'),
                ),
                const PopupMenuItem(
                  value: 'cancelado',
                  child: Text('Cancelado'),
                ),
              ],
              child: const Icon(Icons.edit),
            ),
          ),
        );
      },
    );
  }
}
