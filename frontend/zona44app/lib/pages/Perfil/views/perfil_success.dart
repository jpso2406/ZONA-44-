import 'package:flutter/material.dart';
import 'package:zona44app/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/order.dart';
import '../../../services/user_service.dart';
import '../Admin/OrderAdmin/orderAdmin.dart';
import '../Order/Order.dart';

class PerfilSuccess extends StatefulWidget {
  final User user;
  const PerfilSuccess(this.user, {Key? key}) : super(key: key);

  @override
  State<PerfilSuccess> createState() => _PerfilSuccessState();
}

class _PerfilSuccessState extends State<PerfilSuccess> {
  int _selectedTab = 0; // 0: perfil, 1: órdenes, 2: admin (si aplica)
  bool get isAdmin => widget.user.role == 'admin';

  // Add these variables for admin orders state
  List<Order>? _adminOrders;
  bool _adminLoading = false;

  Future<void> _loadAdminOrders() async {
    setState(() {
      _adminLoading = true;
    });
    try {
      // Replace this with your actual admin order fetching logic
      final orders = await UserService().getAdminOrders(widget.user.id as String); // Pass user ID or required argument
      setState(() {
        _adminOrders = orders;
      });
    } catch (e) {
      // Handle error as needed
      setState(() {
        _adminOrders = [];
      });
    } finally {
      setState(() {
        _adminLoading = false;
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 670,
        decoration: const BoxDecoration(
          color: Color.fromARGB(240, 4, 14, 63),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título + icono logout
            Padding(
              padding: const EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedTab == 0
                          ? 'Mi Perfil'
                          : _selectedTab == 1
                          ? 'Mis Órdenes'
                          : 'Pedidos (Admin)',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.orange,
                      size: 28,
                    ),
                    tooltip: 'Cerrar sesión',
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
            ),
            // Iconos de navegación centrados
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.account_circle,
                      color: _selectedTab == 0 ? Colors.orange : Colors.white,
                      size: 36,
                    ),
                    tooltip: 'Datos de perfil',
                    onPressed: () {
                      setState(() => _selectedTab = 0);
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: Icon(
                      Icons.receipt_long,
                      color: _selectedTab == 1 ? Colors.orange : Colors.white,
                      size: 32,
                    ),
                    tooltip: 'Historial de órdenes',
                    onPressed: () {
                      setState(() => _selectedTab = 1);
                    },
                  ),
                  if (isAdmin) ...[
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(
                        Icons.admin_panel_settings,
                        color: _selectedTab == 2 ? Colors.orange : Colors.white,
                        size: 32,
                      ),
                      tooltip: 'Pedidos de todos los usuarios',
                      onPressed: () {
                        setState(() => _selectedTab = 2);
                        if (_adminOrders == null && !_adminLoading) {
                          _loadAdminOrders();
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            // Contenido principal
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 24, 80),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _selectedTab == 0
                    ? ListView(
                        children: [
                          _profileField('Nombre', widget.user.firstName ?? ''),
                          _profileField('Apellido', widget.user.lastName ?? ''),
                          _profileField('Correo', widget.user.email),
                          _profileField('Teléfono', widget.user.phone ?? ''),
                          _profileField('Dirección', widget.user.address ?? ''),
                          _profileField('Ciudad', widget.user.city ?? ''),
                          _profileField(
                            'Departamento',
                            widget.user.department ?? '',
                          ),
                        ],
                      )
                    : _selectedTab == 1
                    ? const OrderView()
                    : const OrderAdminPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.montserrat(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '-',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
