import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/models/order.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class OrderTrackingResult extends StatelessWidget {
  final Order order;

  const OrderTrackingResult({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con número de orden
          Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.orangeAccent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${AppLocalizations.of(context)!.order} #${order.orderNumber}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(order.status).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getStatusDisplayName(context, order.status),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Información del pedido
          _buildInfoSection(context, AppLocalizations.of(context)!.orderInfo, [
            _buildInfoRow(
              context,
              AppLocalizations.of(context)!.date,
              _formatDate(context, order.createdAt),
            ),
            _buildInfoRow(
              context,
              AppLocalizations.of(context)!.deliveryTypeLabel,
              _getDeliveryTypeName(context, order.deliveryType),
            ),
            _buildInfoRow(
              context,
              AppLocalizations.of(context)!.total,
              'S/ ${order.totalAmount.toStringAsFixed(2)}',
            ),
          ]),

          const SizedBox(height: 16),

          // Información del cliente
          _buildInfoSection(
            context,
            AppLocalizations.of(context)!.customerInfo,
            [
              if (order.user != null) ...[
                _buildInfoRow(
                  context,
                  AppLocalizations.of(context)!.fullName,
                  order.user!.fullName,
                ),
                _buildInfoRow(
                  context,
                  AppLocalizations.of(context)!.email,
                  order.user!.email,
                ),
                _buildInfoRow(
                  context,
                  AppLocalizations.of(context)!.type,
                  AppLocalizations.of(context)!.registeredUser,
                ),
              ] else ...[
                _buildInfoRow(
                  context,
                  AppLocalizations.of(context)!.fullName,
                  order.customerName.isNotEmpty
                      ? order.customerName
                      : AppLocalizations.of(context)!.notSpecified,
                ),
                _buildInfoRow(
                  context,
                  AppLocalizations.of(context)!.email,
                  order.customerEmail.isNotEmpty
                      ? order.customerEmail
                      : AppLocalizations.of(context)!.notSpecified,
                ),
                _buildInfoRow(
                  context,
                  AppLocalizations.of(context)!.phone,
                  order.customerPhone.isNotEmpty
                      ? order.customerPhone
                      : AppLocalizations.of(context)!.notSpecified,
                ),
                if (order.deliveryType == 'domicilio') ...[
                  _buildInfoRow(
                    context,
                    AppLocalizations.of(context)!.address,
                    order.customerAddress.isNotEmpty
                        ? order.customerAddress
                        : AppLocalizations.of(context)!.notSpecified,
                  ),
                  _buildInfoRow(
                    context,
                    AppLocalizations.of(context)!.city,
                    order.customerCity.isNotEmpty
                        ? order.customerCity
                        : AppLocalizations.of(context)!.notSpecified,
                  ),
                ],
                _buildInfoRow(
                  context,
                  AppLocalizations.of(context)!.type,
                  AppLocalizations.of(context)!.guestCustomer,
                ),
              ],
            ],
          ),

          const SizedBox(height: 16),

          // Productos
          _buildProductsSection(context, order),

          const SizedBox(height: 20),

          // Botón de pago si está pendiente
          if (order.status.toLowerCase() == 'pending')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implementar pago desde seguimiento
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(
                          context,
                        )!.paymentFeatureInDevelopment,
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                icon: const Icon(Icons.payment),
                label: Text(AppLocalizations.of(context)!.payOrder),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 239, 131, 7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(BuildContext context, Order order) {
    // Debug: Imprimir información de la orden
    print('🔍 Debug Order Items: ${order.orderItems.length}');
    for (var item in order.orderItems) {
      print('📦 Item: ${item.producto.name} - Qty: ${item.quantity}');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.purchasedProducts} (${order.orderItems.length})',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              if (order.orderItems.isEmpty)
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.noProductsInOrder,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Debug: orderItems.length = ${order.orderItems.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              else
                ...order.orderItems.map(
                  (item) => _buildProductItem(context, item),
                ),

              // Línea divisoria antes del total
              if (order.orderItems.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(height: 1, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                // Total de la orden
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.orderTotal,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'S/ ${order.totalAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, dynamic item) {
    // Debug directo en el widget
    print('🔍 Building product item:');
    print('  - Producto name: "${item.producto.name}"');
    print('  - Producto id: ${item.producto.id}');
    print('  - Quantity: ${item.quantity}');
    print('  - Unit price: ${item.unitPrice}');
    print('  - Total price: ${item.totalPrice}');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del producto
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.orangeAccent,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.producto.name.isEmpty
                      ? AppLocalizations.of(context)!.productWithoutName
                      : item.producto.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Detalles del producto en filas separadas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.quantity,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${item.quantity}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.unitPrice,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'S/ ${item.unitPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)!.total,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'S/ ${item.totalPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return AppLocalizations.of(context)!.unknownDate;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getDeliveryTypeName(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'domicilio':
        return AppLocalizations.of(context)!.homeDelivery;
      case 'recoger':
        return AppLocalizations.of(context)!.pickupAtStore;
      default:
        return type;
    }
  }

  String _getStatusDisplayName(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppLocalizations.of(context)!.statusPending;
      case 'processing':
        return AppLocalizations.of(context)!.statusProcessing;
      case 'paid':
        return AppLocalizations.of(context)!.statusPaid;
      case 'failed':
        return AppLocalizations.of(context)!.statusFailed;
      case 'cancelled':
        return AppLocalizations.of(context)!.statusCancelled;
      default:
        return status.isEmpty
            ? AppLocalizations.of(context)!.statusPending
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
        return status.isEmpty ? Colors.orange : Colors.blueAccent;
    }
  }
}
