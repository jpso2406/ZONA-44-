import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class PromocionesPage extends StatelessWidget {
  const PromocionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Promociones"),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeProvider.toggleTheme(),
        child: Icon(isDarkMode ? Icons.wb_sunny : Icons.dark_mode),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.local_offer, color: Colors.redAccent),
              title: Text("Promo 2x1 en hamburguesas"),
              subtitle: Text("Solo por tiempo limitado"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.local_offer, color: Colors.redAccent),
              title: Text("Bebida gratis con tu combo"),
              subtitle: Text("Todos los viernes"),
            ),
          ),
        ],
      ),
    );
  }
}
