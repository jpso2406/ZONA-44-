import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/pages/Carrito/bloc/carrito_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductDetailModal extends StatefulWidget {
  final Producto producto;
  const ProductDetailModal({super.key, required this.producto});

  @override
  State<ProductDetailModal> createState() => _ProductDetailModalState();
}

class _ProductDetailModalState extends State<ProductDetailModal> {
  bool showSuccess = false;

  void _addToCart(BuildContext context) {
    context.read<CarritoBloc>().add(AgregarProducto(widget.producto));
    setState(() => showSuccess = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.producto.fotoUrl,
                      width: double.infinity,
                      height: size.height * 0.25,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: size.height * 0.25,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: size.height * 0.25,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.fastfood,
                          size: 60,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  if (showSuccess)
                    Positioned.fill(
                      child: Center(
                        child:
                            Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 80,
                                )
                                .animate()
                                .scale(duration: 400.ms)
                                .fadeIn(duration: 400.ms)
                                .then()
                                .shake(duration: 400.ms),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.producto.name,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                widget.producto.descripcion,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                '\$${widget.producto.precio}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 239, 131, 7),
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.orangeAccent.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: showSuccess ? null : () => _addToCart(context),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: Text(
                    'Agregar al carrito',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 131, 7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
