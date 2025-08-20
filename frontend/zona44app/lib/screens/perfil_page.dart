import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart';
import '../main.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  File? _avatarImage;
  final picker = ImagePicker();

  String nombre = "Josue Torres";
  String email = "josue.torres@email.com";
  String telefono = "+57 300 123 4567";

  List<String> historialPedidos = [
    "Pizza Napolitana - 15/08/2025",
    "Hamburguesa Doble - 13/08/2025",
    "Combo Familiar - 10/08/2025",
  ];

  bool autoTema = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      autoTema = prefs.getBool("autoTema") ?? false;
    });
    if (autoTema) {
      _aplicarTemaAutomatico();
    }
  }

  Future<void> _guardarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("autoTema", autoTema);
  }

  void _aplicarTemaAutomatico() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final hora = DateTime.now().hour;
    if (hora >= 6 || hora < 19) {
      themeProvider.setDarkMode();
    } else {
      themeProvider.setLightMode();
    }
  }

  Future<void> _cambiarAvatar() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  void _editarDatos() {
    showDialog(
      context: context,
      builder: (context) {
        final nombreController = TextEditingController(text: nombre);
        final emailController = TextEditingController(text: email);
        final telefonoController = TextEditingController(text: telefono);

        return AlertDialog(
          title: const Text("Editar perfil"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: nombreController, decoration: const InputDecoration(labelText: "Nombre")),
                TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
                TextField(controller: telefonoController, decoration: const InputDecoration(labelText: "Teléfono")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  nombre = nombreController.text;
                  email = emailController.text;
                  telefono = telefonoController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editarDatos,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _cambiarAvatar,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.redAccent,
                backgroundImage: _avatarImage != null ? FileImage(_avatarImage!) : null,
                child: _avatarImage == null
                    ? Text(
                        nombre.isNotEmpty ? nombre[0] : "U",
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              nombre,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(email, style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[700])),
            const SizedBox(height: 6),
            Text(telefono, style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[700])),

            const SizedBox(height: 24),
            SwitchListTile(
              value: autoTema,
              onChanged: (value) {
                setState(() {
                  autoTema = value;
                });
                _guardarPreferencias();
                if (value) _aplicarTemaAutomatico();
              },
              title: const Text("Tema automático según hora"),
              secondary: const Icon(Icons.brightness_6),
            ),

            const Divider(),

            // Historial de pedidos
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Historial de pedidos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...historialPedidos.map((pedido) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.receipt_long, color: Colors.redAccent),
                          title: Text(pedido),
                        ),
                      )),
                ],
              ),
            ),
            const Divider(),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeProvider.toggleTheme(),
        child: Icon(isDarkMode ? Icons.wb_sunny : Icons.dark_mode),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
