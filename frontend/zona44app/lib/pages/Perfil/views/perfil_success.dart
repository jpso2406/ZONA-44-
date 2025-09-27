import 'package:flutter/material.dart';
import 'package:zona44app/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Order/Order.dart';

class PerfilSuccess extends StatefulWidget {
  final User user;
  const PerfilSuccess(this.user, {Key? key}) : super(key: key);

  @override
  State<PerfilSuccess> createState() => _PerfilSuccessState();
}

class _PerfilSuccessState extends State<PerfilSuccess> {
  int _selectedTab = 0; // 0: perfil, 1: órdenes

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

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
                      _selectedTab == 0 ? 'Mi Perfil' : 'Mis Órdenes',
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
                    : const OrderView(),
              ),
            ),
            // ...
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
