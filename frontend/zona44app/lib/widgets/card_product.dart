import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/pages/Carrito/bloc/carrito_bloc.dart';
import '../models/producto.dart';

class CardProducto extends StatelessWidget {
  final Producto producto;

  const CardProducto({required this.producto, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.35,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Flexible(
              flex: 4, // Reducido de 5 a 4
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    producto.fotoUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.fastfood,
                        size: 60,
                        color: Colors.grey[600],
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5, // Reducido de 6 a 5
              child: Padding(
                padding: const EdgeInsets.all(8), // Reducido de 12 a 8
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Añadido
                  children: [
                    Text(
                      producto.name,
                      style: const TextStyle(
                        fontSize: 13, // Reducido de 14 a 13
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2), // Reducido de 4 a 2
                    Text(
                      producto.descripcion,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ), // Reducido de 12 a 11
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '\$${producto.precio}',
                      style: const TextStyle(
                        fontSize: 15, // Reducido de 16 a 15
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 239, 131, 7),
                      ),
                    ),
                    const SizedBox(height: 24), // Reducido de 8 a 4
                    SizedBox(
                      width: double.infinity,
                      height: 32, // Altura fija para el botón
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.read<CarritoBloc>().add(
                            AgregarProducto(producto),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        label: const Text('Agregar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            239,
                            131,
                            7,
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
