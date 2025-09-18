import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/pages/Carrito/bloc/carrito_bloc.dart';

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
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Imagen del producto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                producto.fotoUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
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
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${producto.precio}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 239, 131, 7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Controles de cantidad
            Column(
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        context.read<CarritoBloc>().add(
                          AgregarProducto(producto),
                        );
                      },
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    context.read<CarritoBloc>().add(
                      RemoverProducto(producto.id),
                    );
                  },
                  child: const Text(
                    'Eliminar',
                    style: TextStyle(
                      color: Color.fromARGB(255, 239, 131, 7),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
