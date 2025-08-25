import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart'; // 👈 agregado shimmer
import 'package:zona44app/providers/carrito_provider.dart';
import '../providers/theme_provider.dart';

class Grupo {
  final int id;
  final String nombre;
  final String slug;
  final List<Producto> productos;

  Grupo({
    required this.id,
    required this.nombre,
    required this.slug,
    required this.productos,
  });

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

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    this.fotoUrl,
  });

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
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/v1/grupos'));
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
      body: RefreshIndicator(
        onRefresh: fetchGrupos,
        child: isLoading
            ? buildShimmerLoader() // 👈 shimmer mientras carga backend
            : errorMsg != null
                ? Center(
                    child: Text(errorMsg!,
                        style: const TextStyle(color: Colors.red)))
                : grupos.isEmpty
                    ? const Center(child: Text("No hay productos para mostrar."))
                    : DefaultTabController(
                        length: grupos.length,
                        child: Column(
                          children: [
                            // Header con degradado y buscador
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 50, left: 16, right: 16, bottom: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isDarkMode
                                      ? [Colors.black87, Colors.grey[850]!]
                                      : [Colors.redAccent, Colors.deepOrange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(20)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInDown(
                                    child: const Text(
                                      "Bienvenido 🍽️",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  FadeIn(
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          searchQuery = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Buscar productos...",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[600]),
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Carrusel de promos
                            SizedBox(
                              height: 70,
                              child: PageView(
                                controller: PageController(viewportFraction: 0.9),
                                children: [
                                  promoCard("🔥 2x1 en Hamburguesas", accentColor),
                                  promoCard("🌮 Martes de Tacos", accentColor),
                                  promoCard(
                                      "🥤 Bebida Gratis con tu combo", accentColor),
                                ],
                              ),
                            ),

                            // TabBar dinámico
                            TabBar(
                              isScrollable: true,
                              indicatorColor: accentColor,
                              labelColor: accentColor,
                              unselectedLabelColor: textColor,
                              tabs: grupos.map((g) => Tab(text: g.nombre)).toList(),
                            ),

                            // Contenido
                            Expanded(
                              child: TabBarView(
                                children: grupos.map((grupo) {
                                  final productosFiltrados = grupo.productos
                                      .where((p) => p.nombre
                                          .toLowerCase()
                                          .contains(searchQuery.toLowerCase()))
                                      .toList();

                                  return productosFiltrados.isEmpty
                                      ? const Center(
                                          child: Text(
                                              "No hay productos en esta categoría"))
                                      : buildProductosScroll(
                                          productosFiltrados, textColor, accentColor);
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }

  // 🔄 Shimmer Loader cuando carga backend
  Widget buildShimmerLoader() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.all(12),
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget buildProductosScroll(
      List<Producto> productos, Color textColor, Color accentColor) {
    return SizedBox(
      height: 240,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Row(
          children: productos.map((producto) {
            return ZoomIn(
              child: Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.2), // efecto vidrio
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  backgroundBlendMode: BlendMode.overlay,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: (producto.fotoUrl != null &&
                                      producto.fotoUrl!.isNotEmpty)
                                  ? Image.network(
                                      producto.fotoUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image_not_supported,
                                          size: 60, color: Colors.grey),
                                    ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: FloatingActionButton.small(
                                backgroundColor: accentColor,
                                onPressed: () {
                                Provider.of<CarritoProvider>(context, listen: false)
                                    .agregarProducto(producto);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${producto.nombre} agregado al carrito 🛒"),
                                  ),
                                );
                              },

                                child: const Icon(Icons.add, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              producto.nombre,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${producto.precio}",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget promoCard(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
