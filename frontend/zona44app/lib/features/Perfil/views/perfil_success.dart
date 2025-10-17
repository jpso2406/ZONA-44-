import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona44app/features/Perfil/bloc/perfil_bloc.dart';
import '../../../models/order.dart';
import '../../../services/user_service.dart';
import 'package:zona44app/features/Perfil/Admin/OrderAdmin/order_admin.dart';
import '../../../features/Perfil/Order/Order.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/delete_account_dialog.dart';

class PerfilSuccess extends StatefulWidget {
  final User user;
  const PerfilSuccess(this.user, {Key? key}) : super(key: key);

  @override
  State<PerfilSuccess> createState() => _PerfilSuccessState();
}

class _PerfilSuccessState extends State<PerfilSuccess> {
  int _selectedTab = 0; // 0: perfil, 1: órdenes, 2: admin (si aplica)
  bool get isAdmin => widget.user.role == 'admin';
  late User _currentUser;

  // Add these variables for admin orders state
  List<Order>? _adminOrders;
  bool _adminLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  Future<void> _loadAdminOrders() async {
    setState(() {
      _adminLoading = true;
    });
    try {
      // Replace this with your actual admin order fetching logic
      final orders = await UserService().getAdminOrders(
        widget.user.id as String,
      ); // Pass user ID or required argument
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

    // Recargar el perfil para mostrar el estado de no autenticado
    if (context.mounted) {
      context.read<PerfilBloc>().add(PerfilLoadRequested());
    }
  }

  Future<void> _editProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se encontró el token de autenticación'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final wasUpdated = await EditProfileDialog(
      user: _currentUser,
      token: token,
    ).show(context);

    print('EditProfileDialog returned: $wasUpdated'); // Debug log

    // Si se actualizó exitosamente, recargar los datos del perfil desde el backend
    if (wasUpdated == true) {
      print('Recargando perfil...'); // Debug log
      await _reloadUserProfile(token);
    }
  }

  Future<void> _reloadUserProfile(String token) async {
    try {
      final updatedUser = await UserService().getProfile(token);
      setState(() {
        _currentUser = updatedUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al recargar perfil: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No se encontró el token de autenticación'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirmed = await DeleteAccountDialog(token: token).show(context);

    if (confirmed == true) {
      // La cuenta fue eliminada exitosamente, cerrar sesión
      await _logout(context);
    }
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
                    ? Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                _profileField(
                                  'Nombre',
                                  _currentUser.firstName ?? '',
                                ),
                                _profileField(
                                  'Apellido',
                                  _currentUser.lastName ?? '',
                                ),
                                _profileField('Correo', _currentUser.email),
                                _profileField(
                                  'Teléfono',
                                  _currentUser.phone ?? '',
                                ),
                                _profileField(
                                  'Dirección',
                                  _currentUser.address ?? '',
                                ),
                                _profileField(
                                  'Ciudad',
                                  _currentUser.city ?? '',
                                ),
                                _profileField(
                                  'Departamento',
                                  _currentUser.department ?? '',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _editProfile,
                                  icon: const Icon(Icons.edit),
                                  label: const Text('Editar Perfil'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      239,
                                      131,
                                      7,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _deleteAccount,
                                  icon: const Icon(Icons.delete_forever),
                                  label: const Text('Eliminar Cuenta'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
