import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/Carrito/bloc/carrito_bloc.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Tarjeta individual para cada ítem en el carrito
class CartItemCard extends StatelessWidget {
  final Producto producto;
  final int cantidad;

  const CartItemCard({
    required this.producto,
    required this.cantidad,
    super.key,
    required CarritoItem item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: producto.fotoUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.fastfood, color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Información del producto
            Expanded(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${producto.precio}',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 239, 131, 7),
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          // ignore: deprecated_member_use
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
            // Controles de cantidad
            _QuantityControls(context),
          ],
        ),
      ),
    );
  }

  // Controles para aumentar, disminuir o eliminar el producto del carrito
  // ignore: non_constant_identifier_names
  Column _QuantityControls(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                context.read<CarritoBloc>().add(
                  ActualizarCantidad(producto.id, cantidad - 1),
                );
              },
            ),
            Text(
              '$cantidad',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                context.read<CarritoBloc>().add(AgregarProducto(producto));
              },
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            context.read<CarritoBloc>().add(RemoverProducto(producto.id));
          },
          child: Text(
            AppLocalizations.of(context)!.remove,
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 239, 131, 7),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
