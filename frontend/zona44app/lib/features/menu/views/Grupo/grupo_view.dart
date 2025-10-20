import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/menu/bloc/menu_bloc.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class GruposView extends StatefulWidget {
  final List<Grupo> grupos;

  const GruposView({required this.grupos, Key? key}) : super(key: key);

  @override
  State<GruposView> createState() => _GruposViewState();
}

class _GruposViewState extends State<GruposView> {
  String _searchQuery = '';
  List<Grupo> _filteredGrupos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredGrupos = widget.grupos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGrupos(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredGrupos = widget.grupos;
      } else {
        _filteredGrupos = widget.grupos
            .where((grupo) => grupo.nombre.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterGrupos('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0E27),
            Color(0xFF0A2E6E),
            Color(0xFF0A2E6E),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, widget.grupos.length),
            _buildSearchBar(),
            Expanded(
              child: _filteredGrupos.isEmpty
                  ? _buildEmptyState(context)
                  : _buildCategoriesGrid(context, _filteredGrupos),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [const Color(0xFFEF8307), Color.fromARGB(255, 226, 121, 0)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEF8307).withOpacity(0.8),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.categories,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      height: 3,
                      width: 35,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '$count categorías',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.local_fire_department_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterGrupos,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar categorías...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.white.withOpacity(0.5),
            size: 22,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, List<Grupo> grupos) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula el crossAxisCount basado en el ancho disponible
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        final spacing = 14.0;
        final horizontalPadding = 16.0;
        
        // Calcula el ancho disponible para cada card
        final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
        final cardWidth = (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        final cardHeight = cardWidth * 1.15; // Ratio optimizado
        
        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(horizontalPadding, 4, horizontalPadding, 20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemCount: grupos.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 350 + (index * 80)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: _EnhancedCardGroup(
                      grupo: grupos[index],
                      onTap: () {
                        context.read<MenuBloc>().add(SelectGrupo(grupos[index].slug));
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.03),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 60,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _searchQuery.isEmpty ? 'No hay categorías' : 'Sin resultados',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isEmpty
                  ? 'Las categorías aparecerán aquí'
                  : 'Intenta con otra búsqueda',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Card mejorada con mejor manejo de tamaños
class _EnhancedCardGroup extends StatefulWidget {
  final Grupo grupo;
  final VoidCallback onTap;

  const _EnhancedCardGroup({
    required this.grupo,
    required this.onTap,
  });

  @override
  State<_EnhancedCardGroup> createState() => _EnhancedCardGroupState();
}

class _EnhancedCardGroupState extends State<_EnhancedCardGroup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),
      child: MouseRegion(
        onEnter: (_) => _controller.forward(),
        onExit: (_) => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnim.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B9D)
                          .withOpacity(0.25 * _controller.value),
                      blurRadius: 16 * _controller.value,
                      spreadRadius: 2 * _controller.value,
                      offset: Offset(0, 6 * _controller.value),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagen de fondo
                      Image.network(
                        widget.grupo.fotoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF6366F1).withOpacity(0.7),
                                  const Color(0xFF8B5CF6).withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.restaurant_rounded,
                                color: Colors.white.withOpacity(0.5),
                                size: 40,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: const Color(0xFF1A1F3A),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white.withOpacity(0.3),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      // Overlay gradiente
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.75),
                            ],
                          ),
                        ),
                      ),
                      
                      // Brillo en hover
                      if (_controller.value > 0)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.12 * _controller.value),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      
                      // Badge superior
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              _controller.value > 0.5 ? 0.25 : 0.15,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Icon(
                            Icons.restaurant_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      
                      // Contenido inferior
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.9),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.grupo.nombre,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black38,
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    height: 2.5,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6B9D),
                                          Color(0xFFFFA07A),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 14,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}