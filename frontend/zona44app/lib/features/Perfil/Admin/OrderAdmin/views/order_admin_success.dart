import 'package:flutter/material.dart';
import 'package:zona44app/models/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';
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
          AppLocalizations.of(context)!.noOrdersToDisplay,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        final statusName = _getStatusDisplayName(context, order.status);
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          title: Text(
            AppLocalizations.of(
              context,
            )!.orderNumberAdmin(order.orderNumber.toString()),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              AppLocalizations.of(context)!.statusWithValue(statusName),
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

String _getStatusDisplayName(BuildContext context, String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return AppLocalizations.of(context)!.orderStatusPending;
    case 'processing':
      return AppLocalizations.of(context)!.orderStatusProcessing;
    case 'paid':
      return AppLocalizations.of(context)!.orderStatusPaid;
    case 'failed':
      return AppLocalizations.of(context)!.orderStatusFailed;
    case 'cancelled':
      return AppLocalizations.of(context)!.orderStatusCancelled;
    default:
      return status.isEmpty
          ? AppLocalizations.of(context)!.orderStatusPending
          : status;
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
