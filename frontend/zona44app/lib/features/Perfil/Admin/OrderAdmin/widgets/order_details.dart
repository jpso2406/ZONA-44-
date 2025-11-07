import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/models/order.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class OrderDetails extends StatefulWidget {
  final Order order;
  final void Function(int orderId, String newStatus)? onUpdateStatus;

  const OrderDetails({super.key, required this.order, this.onUpdateStatus});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  static const List<String> estadosPermitidos = [
    'pending',
    'processing',
    'paid',
    'cancelled',
  ];
  late String _selectedStatus;
  bool _loading = false;
  String? _bannerMessage;
  Color _bannerColor = Colors.green;

  @override
  void initState() {
    super.initState();
    _selectedStatus = estadosPermitidos.contains(widget.order.status)
        ? widget.order.status
        : estadosPermitidos.first;
  }

  Future<void> _actualizarEstado(String nuevoEstado) async {
    setState(() {
      _loading = true;
      _bannerMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No autenticado');

      final updatedOrder = await UserService().updateOrderStatus(
        token,
        widget.order.id,
        nuevoEstado,
      );

      setState(() {
        _bannerMessage = AppLocalizations.of(
          context,
        )!.statusUpdatedSuccessfully;
        _bannerColor = Colors.green;
        // Sanitizamos y garantizamos que el valor exista en la lista del dropdown
        final sanitized = (updatedOrder.status).trim().toLowerCase();
        if (!estadosPermitidos.contains(sanitized)) {
          // Si el backend retornó un estado inesperado, no rompemos el dropdown:
          // mantenemos el anterior y mostramos advertencia suave.
          _bannerMessage = AppLocalizations.of(
            context,
          )!.statusUpdatedNonStandard(sanitized);
          _selectedStatus = _selectedStatus; // mantener
        } else {
          _selectedStatus = sanitized;
        }
      });

      // Llamar al callback inmediatamente para recargar la lista
      widget.onUpdateStatus?.call(widget.order.id, nuevoEstado);

      // Cerrar el modal automáticamente después de mostrar el mensaje de éxito
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    } catch (_) {
      setState(() {
        _bannerMessage = AppLocalizations.of(context)!.errorUpdatingStatus;
        _bannerColor = Colors.red;
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  // Genera los items seguros para el dropdown garantizando que exista exactamente
  // un item que coincida con el valor seleccionado.
  List<String> _buildStatusOptions() {
    final base = List<String>.from(estadosPermitidos);
    if (_selectedStatus.isNotEmpty && !base.contains(_selectedStatus)) {
      base.add(_selectedStatus); // incluir estado no estándar para evitar crash
    }
    // Evitar duplicados accidentales
    final distinct = <String>{};
    final result = <String>[];
    for (final s in base) {
      if (distinct.add(s)) result.add(s);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color.fromARGB(255, 10, 24, 80),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner de feedback
                if (_bannerMessage != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: _bannerColor.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _bannerColor == Colors.green
                              ? Icons.check_circle
                              : Icons.error,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _bannerMessage!,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Dropdown de estado
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 130,
                        minWidth: 90,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedStatus,
                            dropdownColor: const Color.fromARGB(
                              255,
                              10,
                              24,
                              80,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w600,
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.orangeAccent,
                            ),
                            items: _buildStatusOptions().map((estado) {
                              String label;
                              switch (estado) {
                                case 'pending':
                                  label = AppLocalizations.of(
                                    context,
                                  )!.orderStatusPending;
                                  break;
                                case 'processing':
                                  label = AppLocalizations.of(
                                    context,
                                  )!.orderStatusProcessing;
                                  break;
                                case 'paid':
                                  label = AppLocalizations.of(
                                    context,
                                  )!.orderStatusPaid;
                                  break;
                                case 'cancelled':
                                  label = AppLocalizations.of(
                                    context,
                                  )!.orderStatusCancelled;
                                  break;
                                default:
                                  label = estado;
                              }
                              return DropdownMenuItem<String>(
                                value: estado,
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              if (value != null && value != _selectedStatus) {
                                await _actualizarEstado(value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.orangeAccent,
                            strokeWidth: 2.4,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Lista de productos
                Text(
                  AppLocalizations.of(context)!.productsLabel,
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

                const SizedBox(height: 14),
                // Total completo separado para mejor visibilidad
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orangeAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.totalAmount,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '\$ ${widget.order.totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.orangeAccent,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Información del cliente/usuario
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.orangeAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.orangeAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            AppLocalizations.of(context)!.customerInformation,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Mostrar información del usuario logueado o datos del cliente
                      if (widget.order.user != null) ...[
                        // Usuario logueado
                        _buildInfoRow(
                          Icons.person_outline,
                          AppLocalizations.of(context)!.name,
                          widget.order.user!.fullName,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.email_outlined,
                          AppLocalizations.of(context)!.email,
                          widget.order.user!.email,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.badge_outlined,
                          AppLocalizations.of(context)!.userId,
                          widget.order.user!.id.toString(),
                        ),
                      ] else ...[
                        // Cliente sin cuenta
                        _buildInfoRow(
                          Icons.person_outline,
                          AppLocalizations.of(context)!.name,
                          widget.order.customerName.isNotEmpty
                              ? widget.order.customerName
                              : AppLocalizations.of(context)!.notSpecified,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.email_outlined,
                          AppLocalizations.of(context)!.email,
                          widget.order.customerEmail.isNotEmpty
                              ? widget.order.customerEmail
                              : AppLocalizations.of(context)!.notSpecified,
                        ),
                        const SizedBox(height: 4),
                        _buildInfoRow(
                          Icons.phone_outlined,
                          AppLocalizations.of(context)!.phone,
                          widget.order.customerPhone.isNotEmpty
                              ? widget.order.customerPhone
                              : AppLocalizations.of(context)!.notSpecified,
                        ),
                        const SizedBox(height: 4),
                        if (widget.order.deliveryType == 'domicilio') ...[
                          _buildInfoRow(
                            Icons.home_outlined,
                            AppLocalizations.of(context)!.address,
                            widget.order.customerAddress.isNotEmpty
                                ? widget.order.customerAddress
                                : AppLocalizations.of(context)!.notSpecified,
                          ),
                          const SizedBox(height: 4),
                          _buildInfoRow(
                            Icons.location_city_outlined,
                            AppLocalizations.of(context)!.city,
                            widget.order.customerCity.isNotEmpty
                                ? widget.order.customerCity
                                : AppLocalizations.of(context)!.notSpecified,
                          ),
                          const SizedBox(height: 4),
                        ],
                        _buildInfoRow(
                          Icons.info_outline,
                          AppLocalizations.of(context)!.type,
                          AppLocalizations.of(context)!.customerWithoutAccount,
                          valueColor: Colors.amber,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Botón cerrar
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.close,
                      style: const TextStyle(color: Colors.orangeAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Overlay cargando
          if (_loading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.35),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orangeAccent,
                    strokeWidth: 4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
