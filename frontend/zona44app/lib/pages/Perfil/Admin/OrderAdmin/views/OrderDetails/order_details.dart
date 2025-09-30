import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/models/order.dart';

import 'package:zona44app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  final void Function(int orderId, String newStatus)? onUpdateStatus;

  const OrderDetails({super.key, required this.order, this.onUpdateStatus});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  static const List<String> estadosPermitidos = ['processing', 'paid'];
  late String _selectedStatus;
  bool _loading = false;
  String? _bannerMessage;
  Color _bannerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    if (estadosPermitidos.contains(widget.order.status)) {
      _selectedStatus = widget.order.status;
    } else {
      _selectedStatus = estadosPermitidos.first;
    }
  }

  Future<void> _actualizarEstado(String nuevoEstado) async {
    setState(() => _loading = true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 10, 24, 80),
        elevation: 0,
        content: Row(
          children: [
            const CircularProgressIndicator(color: Colors.orangeAccent, strokeWidth: 3),
            const SizedBox(width: 18),
            Text('Actualizando estado...', style: GoogleFonts.poppins(color: Colors.white)),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No autenticado');
      await UserService().updateOrderStatus(
        token,
        widget.order.id,
        nuevoEstado,
      );
      if (widget.onUpdateStatus != null) {
        widget.onUpdateStatus!(widget.order.id, nuevoEstado);
      }
      if (mounted) {
        setState(() {
          _bannerMessage = 'Estado actualizado correctamente';
          _bannerColor = Colors.green;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _bannerMessage = 'Error actualizando estado';
          _bannerColor = Colors.red;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formatDate(DateTime date) {
      return "${date.day}/${date.month}/${date.year}";
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color.fromARGB(255, 10, 24, 80),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_bannerMessage != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: _bannerColor.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(_bannerColor == Colors.green ? Icons.check_circle : Icons.error,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _bannerMessage!,
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _bannerMessage = null),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Cabecera: Número de pedido y fecha
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Pedido #${widget.order.orderNumber}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.order.createdAt != null
                        ? _formatDate(widget.order.createdAt!)
                        : 'Fecha desconocida',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Estado editable y total
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedStatus,
                        dropdownColor: const Color.fromARGB(255, 10, 24, 80),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w600,
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.orangeAccent,
                        ),
                        items: estadosPermitidos.map((estado) {
                          String label = '';
                          switch (estado) {
                            case 'processing':
                              label = 'En proceso';
                              break;
                            case 'paid':
                              label = 'Finalizado';
                              break;
                            default:
                              label = estado;
                          }
                          return DropdownMenuItem(
                            value: estado,
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.orangeAccent,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (value != null && value != _selectedStatus) {
                            setState(() => _selectedStatus = value);
                            await _actualizarEstado(value);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Total: S/ ${widget.order.totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.orangeAccent,
                          strokeWidth: 2.2,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Productos
              Text(
                'Productos:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.order.orderItems.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: Colors.white24, height: 1),
                  itemBuilder: (context, idx) {
                    final item = widget.order.orderItems[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.producto.name,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'x${item.quantity}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              // Cliente
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: Colors.orangeAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.order.user?.fullName ?? '-',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.orangeAccent, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.order.user?.email ?? '-',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(color: Colors.orangeAccent),
                  ),
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
