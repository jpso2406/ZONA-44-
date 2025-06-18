import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/carrito_bloc.dart';
import '../bloc/carrito_state.dart';
import '../models/carrito_item.dart';

class ResumenCompraScreen extends StatelessWidget {
  const ResumenCompraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de la compra'),
        backgroundColor: Colors.red[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CarritoBloc, CarritoState>(
          builder: (context, state) {
            if (state is CarritoActualizado) {
              final List<CarritoItem> items = state.items;

              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    'No hay productos en el carrito.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              double total = items.fold(0, (sum, item) => sum + item.plato.precio * item.cantidad);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gracias por tu compra en Zona44',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.plato.nombre),
                          subtitle: Text('Cantidad: ${item.cantidad}'),
                          trailing: Text('\$${(item.plato.precio * item.cantidad).toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
