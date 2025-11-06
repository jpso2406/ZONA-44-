import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/menu/bloc/menu_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';

// Vista moderna que muestra los productos de un grupo seleccionado
class ProductosView extends StatefulWidget {
  final Grupo grupo;
  final List<Producto> productos;
  final List<Grupo>
  todosLosGrupos; // Lista de todas las categorías para la pasarela

  const ProductosView({
    required this.grupo,
    required this.productos,
    required this.todosLosGrupos,
    super.key,
  });

  @override
  State<ProductosView> createState() => _ProductosViewState();
}

class _ProductosViewState extends State<ProductosView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Producto> get _filteredProductos {
    if (_searchQuery.isEmpty) return widget.productos;
    return widget.productos
        .where(
          (producto) =>
              producto.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        color: Color(0xFF0A2E6E),
        child: Column(
          children: [
            // 🔍 Header con búsqueda
            _buildHeader(size),

            // 🎯 Pasarela de categorías
            _buildCategoryCarousel(),

            // 📱 Filtros de productos (si hay subcategorías)
            if (widget.productos.isNotEmpty) _buildProductFilters(),

            // 🍽️ Grid de productos
            Expanded(
              child: _filteredProductos.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: _filteredProductos.length,
                      itemBuilder: (context, index) {
                        return CardProducto(
                          producto: _filteredProductos[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF0A2E6E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Botón de regreso y título
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF8307),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    context.read<MenuBloc>().add(GoBackToGrupos());
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: const Color.fromARGB(255, 255, 254, 254),
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.grupo.nombre,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 52), // Espacio para balancear el diseño
            ],
          ),

          const SizedBox(height: 16),

          // Barra de búsqueda
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchProducts,
                      hintStyle: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFEF8307),
                        size: 18,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF8307),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implementar filtros de productos
                  },
                  icon: const Icon(
                    Icons.tune,
                    color: Color.fromARGB(255, 255, 254, 254),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductFilters() {
    // Aquí podrías agregar filtros específicos para productos
    // Por ejemplo: por precio, tiempo de preparación, etc.
    return Container(
      height: 7,
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  Widget _buildCategoryCarousel() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.todosLosGrupos.length,
        itemBuilder: (context, index) {
          final grupo = widget.todosLosGrupos[index];
          final isSelected = grupo.slug == widget.grupo.slug;

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                context.read<MenuBloc>().add(SelectGrupo(grupo.slug));
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEF8307)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFEF8307)
                      : Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  grupo.nombre,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: const Color(0xFFEF8307)),
          const SizedBox(height: 16),
          Text(
            'No se encontraron productos',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 253, 253, 253),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}
