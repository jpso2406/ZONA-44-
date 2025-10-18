import 'package:flutter/material.dart';
import 'package:zona44app/models/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/services/order_service.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No hay pedidos para mostrar.',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            // Botón de limpieza de órdenes huérfanas
            ElevatedButton.icon(
              onPressed: () => _showCleanupDialog(context),
              icon: const Icon(Icons.cleaning_services),
              label: const Text('Limpiar Órdenes Huérfanas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: [
        // Botón de limpieza cuando hay órdenes
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Órdenes (${orders.length})',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCleanupDialog(context),
                icon: const Icon(Icons.cleaning_services, size: 16),
                label: const Text('Limpiar Huérfanas'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Lista de órdenes
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    builder: (context) => OrderDetails(
                      order: order,
                      onUpdateStatus: onUpdateStatus,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // Método para mostrar diálogo de limpieza
  Future<void> _showCleanupDialog(BuildContext context) async {
    // Mostrar diálogo de confirmación
    final shouldCleanup = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Limpiar Órdenes Huérfanas',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar todas las órdenes pendientes de usuarios no logueados que tengan más de 30 minutos?\n\nEstas órdenes no pueden ser pagadas porque los usuarios no tienen acceso al número de orden.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Limpiar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (shouldCleanup == true) {
      await _cleanupOrphanedOrders(context);
    }
  }

  // Método para limpiar órdenes huérfanas
  Future<void> _cleanupOrphanedOrders(BuildContext context) async {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.orange)),
    );

    try {
      // Llamar al servicio de limpieza
      final response = await OrderService().cleanupOrphanedOrders();

      // Cerrar loading
      Navigator.of(context, rootNavigator: true).pop();

      if (response['success'] == true) {
        final cleanedCount = response['cleaned_count'] ?? 0;

        // Mostrar resultado
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              'Limpieza Completada',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Se eliminaron $cleanedCount órdenes huérfanas.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Entendido',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );

        // Recargar la lista de órdenes
        // TODO: Implementar recarga de órdenes
      } else {
        // Mostrar error
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              'Error',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Error al limpiar órdenes huérfanas: ${response['error'] ?? 'Error desconocido'}',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Cerrar',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
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
        builder: (_) => AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Error al limpiar órdenes huérfanas: $e',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Cerrar',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }
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
