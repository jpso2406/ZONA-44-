import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/models/order.dart';

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
                  'Orden #${order.orderNumber}',
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
                  _getStatusDisplayName(order.status),
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
          _buildInfoSection('Información del Pedido', [
            _buildInfoRow('Fecha', _formatDate(order.createdAt)),
            _buildInfoRow(
              'Tipo de Entrega',
              _getDeliveryTypeName(order.deliveryType),
            ),
            _buildInfoRow(
              'Total',
              'S/ ${order.totalAmount.toStringAsFixed(2)}',
            ),
          ]),

          const SizedBox(height: 16),

          // Información del cliente
          _buildInfoSection('Información del Cliente', [
            if (order.user != null) ...[
              _buildInfoRow('Nombre', order.user!.fullName),
              _buildInfoRow('Email', order.user!.email),
              _buildInfoRow('Tipo', 'Usuario registrado'),
            ] else ...[
              _buildInfoRow(
                'Nombre',
                order.customerName.isNotEmpty
                    ? order.customerName
                    : 'No especificado',
              ),
              _buildInfoRow(
                'Email',
                order.customerEmail.isNotEmpty
                    ? order.customerEmail
                    : 'No especificado',
              ),
              _buildInfoRow(
                'Teléfono',
                order.customerPhone.isNotEmpty
                    ? order.customerPhone
                    : 'No especificado',
              ),
              if (order.deliveryType == 'domicilio') ...[
                _buildInfoRow(
                  'Dirección',
                  order.customerAddress.isNotEmpty
                      ? order.customerAddress
                      : 'No especificado',
                ),
                _buildInfoRow(
                  'Ciudad',
                  order.customerCity.isNotEmpty
                      ? order.customerCity
                      : 'No especificado',
                ),
              ],
              _buildInfoRow('Tipo', 'Cliente sin cuenta'),
            ],
          ]),

          const SizedBox(height: 16),

          // Productos
          _buildInfoSection(
            'Productos',
            order.orderItems
                .map(
                  (item) => _buildInfoRow(
                    item.producto.name,
                    'x${item.quantity} - S/ ${item.totalPrice.toStringAsFixed(2)}',
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 20),

          // Botón de pago si está pendiente
          if (order.status.toLowerCase() == 'pending')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implementar pago desde seguimiento
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Funcionalidad de pago desde seguimiento en desarrollo',
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('Pagar Pedido'),
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

  Widget _buildInfoSection(String title, List<Widget> children) {
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

  Widget _buildInfoRow(String label, String value) {
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

  String _formatDate(DateTime? date) {
    if (date == null) return 'Fecha desconocida';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getDeliveryTypeName(String type) {
    switch (type.toLowerCase()) {
      case 'domicilio':
        return 'Domicilio';
      case 'recoger':
        return 'Recoger en tienda';
      default:
        return type;
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
        return status.isEmpty ? Colors.orange : Colors.blueAccent;
    }
  }
}

