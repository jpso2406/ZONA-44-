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
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tu Carrito',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Fondo con imagen
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_llamas.png',
              fit: BoxFit.cover,
            ),
          ),

          // Contenido del carrito
          SafeArea(
            child: BlocBuilder<CarritoBloc, CarritoState>(
              builder: (context, state) {
                if (state is CarritoCargado) {
                  if (state.platos.isEmpty) {
                    return const Center(
                      child: Text(
                        'El carrito está vacío.',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final total = state.platos.fold(
                    0.0,
                    (sum, plato) => sum + plato.precio,
                  );

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.platos.length,
                          itemBuilder: (context, index) {
                            final plato = state.platos[index];
                            return ListTile(
                              title: Text(
                                plato.nombre,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                '\$${plato.precio.toStringAsFixed(2)}',
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
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
