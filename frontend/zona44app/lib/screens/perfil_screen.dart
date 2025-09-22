import 'package:flutter/material.dart';
import '../widgets/perfil_header.dart';
import '../widgets/option_card.dart';
import '../widgets/edit_profile_bottom_sheet.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _confirmLogout() async {
    final should = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que quieres cerrar la sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Cerrar sesión')),
        ],
      ),
    );
    if (should == true) _showSnack('Sesión cerrada');
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color.fromARGB(240, 4, 14, 63);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () => _showSnack('Abrir configuración'))
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, const Color.fromARGB(200, 10, 30, 120)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 18),

              // Aquí irá el header separado
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: PerfilHeader(
                    nombre: 'Joss Torres',
                    email: 'joss@email.com',
                    primary: primary,
                    onAvatarTap: () => _showSnack('Editar avatar'),
                    onEditProfile: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (_) => EditProfileBottomSheet(
                          nombre: 'Joss Torres',
                          email: 'joss@email.com',
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Lista de opciones
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    OptionCard(icon: Icons.shopping_cart, title: 'Mis pedidos', subtitle: 'Ver historial de compras', color: Colors.greenAccent, onTap: () => _showSnack('Ir a Mis pedidos')),
                    OptionCard(icon: Icons.favorite, title: 'Favoritos', subtitle: 'Platos que te encantan', color: Colors.pinkAccent, onTap: () => _showSnack('Ir a Favoritos')),
                    OptionCard(icon: Icons.credit_card, title: 'Métodos de pago', subtitle: 'Tarjetas y efectivo', color: Colors.blueAccent, onTap: () => _showSnack('Ir a Métodos de pago')),
                    OptionCard(icon: Icons.location_on, title: 'Direcciones', subtitle: 'Tus direcciones guardadas', color: Colors.tealAccent, onTap: () => _showSnack('Ir a Direcciones')),
                    OptionCard(icon: Icons.logout, title: 'Cerrar sesión', subtitle: 'Salir de tu cuenta', color: Colors.redAccent, onTap: _confirmLogout),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
