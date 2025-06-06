import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plato_bloc.dart';
import '../bloc/plato_state.dart';

class PlatosScreen extends StatelessWidget {
  final String categoria;

  const PlatosScreen({super.key, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con botón atrás
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // ← vuelve a Categorias
          },
        ),
        title: Text(
          'Platos de $categoria',
          style: const TextStyle(color: Colors.white),
        ),
      ),

      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_llamas.png',
              fit: BoxFit.cover,
            ),
          ),

          // Contenido encima del fondo
          SafeArea(
            child: BlocBuilder<PlatoBloc, PlatoState>(
              builder: (context, state) {
                if (state is PlatoCargado) {
                  final platosFiltrados = state.platos
                      .where((p) => p.categoria == categoria)
                      .toList();

                  if (platosFiltrados.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay platos disponibles para esta categoría.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: platosFiltrados.length,
                    itemBuilder: (context, index) {
                      final plato = platosFiltrados[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plato.nombre,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                plato.descripcion ?? 'Sin descripción',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${plato.precio.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Acción al ordenar
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[700],
                                    ),
                                    child: const Text('Ordenar'),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is PlatoError) {
                  return Center(
                    child: Text(
                      state.mensaje,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
