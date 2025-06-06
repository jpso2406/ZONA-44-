import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plato_bloc.dart';
import '../bloc/plato_state.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/bienvenidos');
          },
        ),
        title: const Text('Menú', style: TextStyle(color: Colors.white)),
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

          // Contenido con categorías en formato visual
          SafeArea(
            child: BlocBuilder<PlatoBloc, PlatoState>(
              builder: (context, state) {
                if (state is PlatoCargando) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PlatoCargado) {
                  final categorias =
                      state.platos.map((p) => p.categoria).toSet().toList();

                  final imagenCategoria = {
                    'Pizzas Tradicionales': 'assets/images/pizza.png',
                    'Pizzas Especiales': 'assets/images/pizza_especial.png',
                    'Hamburguesas': 'assets/images/hamburguesa.png',
                    'Perros Calientes': 'assets/images/perro_caliente.png',
                  };

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = categorias[index];
                      final imagen =
                          imagenCategoria[categoria] ?? 'assets/images/pizza.png';

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/platos',
                            arguments: categoria,
                          );
                        },
                        child: Card(
                          color: Colors.black.withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    imagen,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  categoria,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
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
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
