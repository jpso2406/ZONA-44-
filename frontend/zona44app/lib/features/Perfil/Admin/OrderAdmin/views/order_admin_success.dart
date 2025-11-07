import 'package:flutter/material.dart';
import 'package:zona44app/models/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import '../widgets/order_details.dart';

/// Vista que muestra la lista de órdenes para el admin
/// Permite ver detalles de cada orden al tocarla
/// Usada en OrderAdminPage cuando el estado es OrderAdminSuccessState
class OrderAdminSuccess extends StatefulWidget {
  final List<Order> orders;
  final void Function(int orderId, String newStatus) onUpdateStatus;
  const OrderAdminSuccess({
    super.key,
    required this.orders,
    required this.onUpdateStatus,
  });

  @override
  State<OrderAdminSuccess> createState() => _OrderAdminSuccessState();
}

class _OrderAdminSuccessState extends State<OrderAdminSuccess> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedStatus =
      'all'; // 'all', 'pending', 'processing', 'paid', 'failed', 'cancelled'

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Order> get _filteredOrders {
    var filtered = widget.orders;

    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((order) {
        return order.orderNumber.toString().contains(_searchQuery);
      }).toList();
    }

    // Filtrar por estado
    if (_selectedStatus != 'all') {
      filtered = filtered.where((order) {
        return order.status.toLowerCase() == _selectedStatus;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.orders.isEmpty) {
      return SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.noOrdersToDisplay,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        // Ocultar teclado cuando se toca fuera del campo de búsqueda
        _searchFocusNode.unfocus();
      },
      child: Column(
        children: [
          // 🔍 Barra de búsqueda
          _buildSearchBar(context),

          // 🎯 Pasarela de estados
          _buildStatusCarousel(context),

          // 📋 Lista de órdenes
          Expanded(
            child: _filteredOrders.isEmpty
                ? SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 300,
                      child: _buildEmptyState(context),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      final statusName = _getStatusDisplayName(
                        context,
                        order.status,
                      );
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
                            AppLocalizations.of(
                              context,
                            )!.statusWithValue(statusName),
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
                              onUpdateStatus: widget.onUpdateStatus,
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchByOrderNumber,
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFFEF8307),
              size: 18,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                        _searchFocusNode
                            .unfocus(); // Ocultar teclado al limpiar
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildStatusCarousel(BuildContext context) {
    final statuses = [
      {
        'key': 'all',
        'label': AppLocalizations.of(context)!.allOrders,
        'color': Colors.white70,
      },
      {
        'key': 'pending',
        'label': AppLocalizations.of(context)!.orderStatusPending,
        'color': Colors.orange,
      },
      {
        'key': 'processing',
        'label': AppLocalizations.of(context)!.orderStatusProcessing,
        'color': Colors.blue,
      },
      {
        'key': 'paid',
        'label': AppLocalizations.of(context)!.orderStatusPaid,
        'color': Colors.green,
      },
      {
        'key': 'failed',
        'label': AppLocalizations.of(context)!.orderStatusFailed,
        'color': Colors.red,
      },
      {
        'key': 'cancelled',
        'label': AppLocalizations.of(context)!.orderStatusCancelled,
        'color': Colors.grey,
      },
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status['key'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedStatus = status['key'] as String;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (status['color'] as Color)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? (status['color'] as Color)
                      : Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  status['label'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Color(0xFFEF8307)),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noOrdersToDisplay,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'No se encontraron órdenes con ese número'
                : 'No hay órdenes con ese estado',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
