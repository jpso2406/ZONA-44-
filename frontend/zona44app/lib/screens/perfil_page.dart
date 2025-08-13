import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeProvider.toggleTheme(),
        child: Icon(isDarkMode ? Icons.wb_sunny : Icons.dark_mode),
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Text("Información del usuario", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
