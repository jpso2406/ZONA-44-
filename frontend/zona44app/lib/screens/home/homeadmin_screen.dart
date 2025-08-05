import 'package:flutter/material.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const OrdersScreen(),
    const TransactionsScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.deepOrange,
          secondary: Colors.orange,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Panel Administrador'),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: _isDarkMode ? Colors.grey[400] : Colors.grey,
          backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Estadísticas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'Transacciones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Mi perfil',
            ),
          ],
        ),
      ),
    );
  }
}

// Pantallas

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Aquí irán las estadísticas con gráficos 🎯',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Lista de pedidos recientes 🧾'),
    );
  }
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  final List<Map<String, String>> mockTransactions = const [
    {
      'dish': 'Taco al Pastor',
      'wallet': 'Nequi',
      'amount': '\$12.000',
      'date': '03/08/2025',
    },
    {
      'dish': 'Burrito Mixto',
      'wallet': 'Daviplata',
      'amount': '\$18.500',
      'date': '02/08/2025',
    },
    {
      'dish': 'Nachos Supreme',
      'wallet': 'Bancolombia',
      'amount': '\$15.000',
      'date': '01/08/2025',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mockTransactions.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final tx = mockTransactions[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.monetization_on),
            title: Text('${tx['dish']} - ${tx['amount']}'),
            subtitle: Text('Pagado con ${tx['wallet']} el ${tx['date']}'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Ajustes de la aplicación ⚙️'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Perfil del administrador 👤'),
    );
  }
}
