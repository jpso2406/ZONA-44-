import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/carrito_bloc.dart';
import '../bloc/carrito_state.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Carrito'),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          // Fondo de llamas
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_llamas.png',
              fit: BoxFit.cover,
            ),
          ),
          BlocBuilder<CarritoBloc, CarritoState>(
            builder: (context, state) {
              if (state is CarritoActualizado) {
                if (state.items.isEmpty) {
                  return const Center(
                    child: Text(
                      'El carrito está vacío.',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                double total = state.items.fold(
                    0, (sum, item) => sum + item.plato.precio);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return ListTile(
                            title: Text(
                              item.plato.nombre,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              '\$${item.plato.precio.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is CarritoInicial) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(
                  child: Text(
                    'Error al cargar el carrito.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
