import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class Grupo {
  final int id;
  final String nombre;
  final String slug;
  final List<Producto> productos;

  Grupo({required this.id, required this.nombre, required this.slug, required this.productos});

  factory Grupo.fromJson(Map<String, dynamic> json) {
    var productosJson = json['productos'] as List<dynamic>? ?? [];
    return Grupo(
      id: json['id'],
      nombre: json['nombre'],
      slug: json['slug'],
      productos: productosJson.map((p) => Producto.fromJson(p)).toList(),
    );
  }
}

class Producto {
  final int id;
  final String nombre;
  final dynamic precio;
  final String descripcion;
  final String? fotoUrl;

  Producto({required this.id, required this.nombre, required this.precio, required this.descripcion, this.fotoUrl});

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['name'] ?? 'sin nombre',
      precio: json['precio'],
      descripcion: json['descripcion'] ?? '',
      fotoUrl: json['foto_url'] as String?,
    );
  }
}

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  String searchQuery = "";
  List<Grupo> grupos = [];
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchGrupos();
  }

  Future<void> fetchGrupos() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/v1/grupos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        grupos = data.map((g) => Grupo.fromJson(g)).toList();
      } else {
        errorMsg = 'Error al cargar grupos: ${response.statusCode}';
      }
    } catch (e) {
      errorMsg = 'No se pudo conectar al backend: ${e.toString()}';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final cardColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final accentColor = Colors.redAccent;

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => themeProvider.toggleTheme(),
        child: Icon(isDarkMode ? Icons.wb_sunny : Icons.dark_mode),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(child: Text(errorMsg!, style: const TextStyle(color: Colors.red)))
              : grupos.isEmpty
                  ? const Center(child: Text("No hay productos para mostrar."))
                  : DefaultTabController(
                      length: grupos.length,
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDarkMode
                                    ? [Colors.black87, Colors.grey[850]!]
                                    : [Colors.redAccent, Colors.deepOrange],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Bienvenido 🍽️",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Buscar productos...",
                                    hintStyle: TextStyle(color: Colors.grey[600]),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // TabBar dinámico con categorías
                          TabBar(
                            isScrollable: true,
                            indicatorColor: accentColor,
                            labelColor: accentColor,
                            unselectedLabelColor: textColor,
                            tabs: grupos.map((g) => Tab(text: g.nombre)).toList(),
                          ),

                          // Contenido de cada pestaña
                          Expanded(
                            child: TabBarView(
                              children: grupos.map((grupo) {
                                // Filtrar productos según búsqueda
                                final productosFiltrados = grupo.productos
                                    .where((p) => p.nombre.toLowerCase().contains(searchQuery.toLowerCase()))
                                    .toList();

                                return productosFiltrados.isEmpty
                                    ? const Center(child: Text("No hay productos en esta categoría"))
                                    : GridView.builder(
                                        padding: const EdgeInsets.all(16),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.75,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                        ),
                                        itemCount: productosFiltrados.length,
                                        itemBuilder: (context, index) {
                                          final producto = productosFiltrados[index];
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: cardColor,
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                if (!isDarkMode)
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.05),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                              ],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                                    child: (producto.fotoUrl != null && producto.fotoUrl!.isNotEmpty)
                                                        ? Image.network(
                                                            producto.fotoUrl!,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (context, error, stackTrace) =>
                                                                const Icon(Icons.broken_image, size: 60),
                                                          )
                                                        : Container(
                                                            color: Colors.grey[300],
                                                            child: const Icon(Icons.image_not_supported,
                                                                size: 60, color: Colors.grey),
                                                          ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        producto.nombre,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        "\$${producto.precio}",
                                                        style: TextStyle(
                                                          color: accentColor,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      ElevatedButton(
                                                        onPressed: () {},
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: accentColor,
                                                          minimumSize: const Size.fromHeight(35),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                        ),
                                                        child: const Text("Agregar"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
