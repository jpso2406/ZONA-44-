import 'package:flutter/material.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'product_detail_modal.dart';

// Tarjeta para mostrar un producto
class CardProducto extends StatelessWidget {
  final Producto producto;

  const CardProducto({required this.producto, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => ProductDetailModal(producto: producto),
        );
      },
      child: Container(
        height: size.height * 0.28,
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: CachedNetworkImage(
                  imageUrl: producto.fotoUrl,
                  width: double.infinity,
                  height: size.height * 0.16,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: size.height * 0.16,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: size.height * 0.16,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.fastfood,
                      size: 60,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${producto.precio}',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
