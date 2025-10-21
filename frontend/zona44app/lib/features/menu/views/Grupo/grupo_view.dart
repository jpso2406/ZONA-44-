import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/menu/bloc/menu_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Vista que muestra los grupos de productos con diseño moderno
class GruposView extends StatefulWidget {
  final List<Grupo> grupos;

  const GruposView({required this.grupos, super.key});

  @override
  State<GruposView> createState() => _GruposViewState();
}

class _GruposViewState extends State<GruposView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedBannerIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Grupo> get _filteredGrupos {
    if (_searchQuery.isEmpty) return widget.grupos;
    return widget.grupos
        .where((grupo) => grupo.nombre.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return SafeArea(
      child: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            // 🔍 Barra de búsqueda y filtro
            _buildSearchBar(),
            
            // 🎯 Banner promocional
            _buildPromotionalBanner(size),
            
            // 📱 Filtros de categorías horizontales
            _buildCategoryFilters(),
            
            // 🍽️ Grid de grupos
            Expanded(
              child: _filteredGrupos.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: _filteredGrupos.length,
                      itemBuilder: (context, index) {
                        final grupo = _filteredGrupos[index];
                        return GestureDetector(
                          onTap: () {
                            context.read<MenuBloc>().add(SelectGrupo(grupo.slug));
                          },
                          child: CardGroup(grupo: grupo),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Buscar categorías...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF0A2E6E),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0A2E6E).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Implementar filtros avanzados
              },
              icon: const Icon(
                Icons.tune,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBanner(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: size.height * 0.18, // Reducido para evitar overflow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Contenido del banner
          Padding(
            padding: const EdgeInsets.all(16), // Reducido padding
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '60% OFF',
                        style: GoogleFonts.poppins(
                          fontSize: 24, // Reducido
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6), // Reducido
                      Text(
                        'Oferta Especial\nFin de Semana',
                        style: GoogleFonts.poppins(
                          fontSize: 14, // Reducido
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12), // Reducido
                      GestureDetector(
                        onTap: () {
                          // TODO: Implementar navegación a menú o productos destacados
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Reducido
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF8307),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF8307).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Ordenar Ahora',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Imagen del banner con logo Zona44
                Container(
                  width: 100, // Reducido
                  height: 100, // Reducido
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Logo Zona44 estilizado
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ZONA',
                              style: GoogleFonts.poppins(
                                fontSize: 16, // Reducido
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '4',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20, // Reducido
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFEF8307),
                                  ),
                                ),
                                Text(
                                  '4',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20, // Reducido
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFEF8307),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'GASTRO-BAR',
                              style: GoogleFonts.poppins(
                                fontSize: 7, // Reducido
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Indicadores de paginación
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == _selectedBannerIndex 
                        ? const Color(0xFFEF8307) 
                        : Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.grupos.length + 1, // +1 para "Todos"
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final isSelected = isAll ? _searchQuery.isEmpty : false;
          
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                if (isAll) {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                } else {
                  final grupo = widget.grupos[index - 1];
                  setState(() {
                    _searchQuery = grupo.nombre;
                    _searchController.text = grupo.nombre;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0A2E6E) : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0A2E6E) : Colors.grey[300]!,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  isAll ? 'Todos' : widget.grupos[index - 1].nombre,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey[700],
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
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron categorías',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
