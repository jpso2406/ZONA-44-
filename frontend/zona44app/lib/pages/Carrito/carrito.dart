import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/carrito_bloc.dart';

class Carrito extends StatelessWidget {
  const Carrito({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 4, 14, 63),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<CarritoBloc, CarritoState>(
          builder: (context, state) {
            if (state is! CarritoLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final items = state.items;
            final total = state.totalPrecio;

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'Tu carrito está vacío',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.producto.fotoUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) =>
                                    const Icon(Icons.fastfood, size: 60),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.producto.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.producto.precio}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final newQty = item.cantidad - 1;
                                    context.read<CarritoBloc>().add(
                                      ActualizarCantidad(
                                        item.producto.id,
                                        newQty,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('${item.cantidad}'),
                                IconButton(
                                  onPressed: () {
                                    context.read<CarritoBloc>().add(
                                      AgregarProducto(item.producto),
                                    );
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<CarritoBloc>().add(
                                      RemoverProducto(item.producto.id),
                                    );
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${total}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 239, 131, 7),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            context.read<CarritoBloc>().add(LimpiarCarrito()),
                        child: const Text('Vaciar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: continuar con flujo de checkout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            239,
                            131,
                            7,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Pagar'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
