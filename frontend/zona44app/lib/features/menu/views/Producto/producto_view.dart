import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/Carrito/bloc/carrito_bloc.dart';
import 'package:zona44app/features/menu/bloc/menu_bloc.dart';

class ProductosView extends StatefulWidget {
  final Grupo grupo;
  final List<Producto> productos;

  const ProductosView({
    required this.grupo,
    required this.productos,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductosView> createState() => _ProductosViewState();
}

class _ProductosViewState extends State<ProductosView> {
  String _searchQuery = '';
  List<Producto> _filteredProductos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProductos = widget.productos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProductos(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredProductos = widget.productos;
      } else {
        _filteredProductos = widget.productos
            .where((producto) =>
                producto.name.toLowerCase().contains(_searchQuery))
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterProductos('');
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
            _buildAppBar(context),
            _buildInfoBar(),
            _buildSearchBar(),
            Expanded(
              child: _filteredProductos.isEmpty
                  ? _buildEmptyState()
                  : _buildProductsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF8307), Color(0xFFEF8307)],
              ),
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFEF8307).withOpacity(0.7),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  context.read<MenuBloc>().add(GoBackToGrupos());
                },
                borderRadius: BorderRadius.circular(16.0),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.grupo.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: 3.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                    ),
                    borderRadius: BorderRadius.circular(2.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4FACFE).withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48.0),
        ],
      ),
    );
  }

  Widget _buildInfoBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 9.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6366F1).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.white,
                  size: 16.0,
                ),
                const SizedBox(width: 6.0),
                Text(
                  '${_filteredProductos.length} ${_filteredProductos.length == 1 ? 'producto' : 'productos'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7.0),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              borderRadius: BorderRadius.circular(18.0),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.4),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF10B981),
                  size: 14.0,
                ),
                SizedBox(width: 5.0),
                Text(
                  'Disponible',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
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
        onChanged: _filterProductos,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
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

  Widget _buildProductsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        final spacing = 12.0;
        final horizontalPadding = 16.0;
        
        final availableWidth = constraints.maxWidth - (horizontalPadding * 2);
        final cardWidth = (availableWidth - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        final cardHeight = cardWidth * 1.6; // Más altura para evitar overflow
        
        return GridView.builder(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 4, horizontalPadding, 20),
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: cardWidth / cardHeight,
          ),
          itemCount: _filteredProductos.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 70)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: _EnhancedCardProducto(
                      producto: _filteredProductos[index],
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

  Widget _buildEmptyState() {
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
                  width: 2.0,
                ),
              ),
              child: Icon(
                _searchQuery.isEmpty
                    ? Icons.shopping_basket_outlined
                    : Icons.search_off_rounded,
                size: 60.0,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              _searchQuery.isEmpty ? 'No hay productos' : 'Sin resultados',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              _searchQuery.isEmpty
                  ? 'Este grupo está vacío'
                  : 'Intenta con otra búsqueda',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Card mejorada de producto con estrellas y precio en COP
class _EnhancedCardProducto extends StatefulWidget {
  final Producto producto;

  const _EnhancedCardProducto({required this.producto});

  @override
  State<_EnhancedCardProducto> createState() => _EnhancedCardProductoState();
}

class _EnhancedCardProductoState extends State<_EnhancedCardProducto>
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
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatPrice(num price) {
    return '\$${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  void _addToCart(BuildContext context) {
    // Agregar al carrito usando BLoC (solo producto, la cantidad se maneja en el BLoC)
    context.read<CarritoBloc>().add(
      AgregarProducto(widget.producto), // ✅
    );
    // Mostrar feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.producto.name} agregado al carrito',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color(0xFF10B981).withOpacity(0.3),
          ),
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ver detalles del producto
      },
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
                      color: const Color(0xFF6366F1)
                          .withOpacity(0.15 * _controller.value),
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
                  child: Container(
                    color: Colors.white.withOpacity(0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Imagen del producto
                        Expanded(
                          flex: 6,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                widget.producto.fotoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF6366F1).withOpacity(0.6),
                                          const Color(0xFF8B5CF6).withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.fastfood_rounded,
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
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Badge de estrella rating
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFA500),
                                        Color(0xFFFF8C00),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFA500).withOpacity(0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        '4.8',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Información del producto
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nombre del producto
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    widget.producto.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.2,
                                      height: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                const SizedBox(height: 4),
                                
                                // Estrellas de rating compactas
                                Row(
                                  children: [
                                    ...List.generate(5, (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 1),
                                        child: Icon(
                                          index < 4
                                              ? Icons.star_rounded
                                              : Icons.star_half_rounded,
                                          color: const Color(0xFFFFA500),
                                          size: 11,
                                        ),
                                      );
                                    }),
                                    const SizedBox(width: 3),
                                    Flexible(
                                      child: Text(
                                        '(125)',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 8,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const Spacer(),
                                
                                // Precio y botón
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              _formatPrice(widget.producto.precio),
                                              style: const TextStyle(
                                                color: Color(0xFF4FACFE),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'COP',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.5),
                                              fontSize: 8,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => _addToCart(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFFF6B9D),
                                              Color(0xFFC06C84),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFF6B9D).withOpacity(0.4),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.add_shopping_cart_rounded,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}