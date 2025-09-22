import 'package:flutter/material.dart';

/// Pantalla "Mi Perfil" mejorada, con:
/// - Fondo en degradado basado en Color.fromARGB(240, 4, 14, 63)
/// - Avatar con borde degradado
/// - Animación de entrada (fade + slide)
/// - Cards interactivos con ripple
/// - Confirmación al cerrar sesión
class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    // Inicia la animación al construir la pantalla
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  // Muestra un SnackBar sencillo
  void _showSnack(String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  // Diálogo de confirmación al cerrar sesión
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

    if (should == true) {
      // Aquí realiza la lógica real de logout (limpiar token, navegar, etc.)
      _showSnack('Sesión cerrada');
    }
  }

  // Widget reutilizable para las opciones del perfil
  Widget _optionCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withOpacity(0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 13,
                            )),
                      ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
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
          IconButton(
            tooltip: 'Ajustes',
            icon: const Icon(Icons.settings),
            onPressed: () => _showSnack('Abrir configuración'),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary,
              const Color.fromARGB(200, 10, 30, 120),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 18),

              // Header con avatar + nombre (animado)
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Column(
                    children: [
                      // Borde degradado alrededor del avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9C27B0), Color(0xFFFF9800)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Puedes abrir picker para cambiar avatar
                            _showSnack('Editar avatar (aquí abrir picker)');
                          },
                          child: const CircleAvatar(
                            radius: 56,
                            backgroundColor: Colors.white,
                            // Si tienes imagen en assets, reemplaza child por:
                            // backgroundImage: AssetImage('assets/images/avatar.png'),
                            child: Icon(Icons.person, size: 56, color: Color.fromARGB(240, 4, 14, 63)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Joss Torres',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'joss@email.com',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Botón editar perfil
                      ElevatedButton.icon(
                        onPressed: () {
                          // Ejemplo: abrir bottom sheet para editar datos
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Editar perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    initialValue: 'Joss Torres',
                                    decoration: const InputDecoration(labelText: 'Nombre'),
                                  ),
                                  TextFormField(
                                    initialValue: 'joss@email.com',
                                    decoration: const InputDecoration(labelText: 'Email'),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      _showSnack('Perfil actualizado (simulado)');
                                    },
                                    child: const Text('Guardar'),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 4,
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Editar perfil'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Lista de opciones
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      _optionCard(
                        icon: Icons.shopping_cart,
                        title: 'Mis pedidos',
                        subtitle: 'Ver historial de compras',
                        color: Colors.greenAccent,
                        onTap: () => _showSnack('Ir a Mis pedidos'),
                      ),
                      const SizedBox(height: 10),
                      _optionCard(
                        icon: Icons.favorite,
                        title: 'Favoritos',
                        subtitle: 'Platos que te encantan',
                        color: Colors.pinkAccent,
                        onTap: () => _showSnack('Ir a Favoritos'),
                      ),
                      const SizedBox(height: 10),
                      _optionCard(
                        icon: Icons.credit_card,
                        title: 'Métodos de pago',
                        subtitle: 'Tarjetas y efectivo',
                        color: Colors.blueAccent,
                        onTap: () => _showSnack('Ir a Métodos de pago'),
                      ),
                      const SizedBox(height: 10),
                      _optionCard(
                        icon: Icons.location_on,
                        title: 'Direcciones',
                        subtitle: 'Tus direcciones guardadas',
                        color: Colors.tealAccent,
                        onTap: () => _showSnack('Ir a Direcciones'),
                      ),
                      const SizedBox(height: 18),

                      // Card de Cerrar sesión con color distinto y confirmación
                      _optionCard(
                        icon: Icons.logout,
                        title: 'Cerrar sesión',
                        subtitle: 'Salir de tu cuenta',
                        color: Colors.redAccent,
                        onTap: _confirmLogout,
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
