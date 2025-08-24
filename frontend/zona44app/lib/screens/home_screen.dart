import 'package:flutter/material.dart';
import 'inicio_page.dart';
import 'promociones_page.dart';
import 'carrito_page.dart';
import 'perfil_page.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    InicioPage(),
    PromocionesPage(),
    CarritoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          if (_selectedIndex == 0) // Solo mostrar en la pantalla de inicio
            Positioned(
              top: 40,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PerfilPage()),
                  );
                },
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: "Promociones"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Carrito"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeProvider.toggleTheme(),
        child: Icon(themeProvider.isDarkMode ? Icons.wb_sunny : Icons.dark_mode),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
