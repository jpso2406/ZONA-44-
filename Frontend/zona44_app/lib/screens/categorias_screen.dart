import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plato_bloc.dart';
import '../bloc/plato_state.dart';

class CategoriasScreen extends StatelessWidget {
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

          // Contenido encima del fondo
          SafeArea(
            child: BlocBuilder<PlatoBloc, PlatoState>(
              builder: (context, state) {
                if (state is PlatoCargando) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PlatoCargado) {
                  final categorias =
                      state.platos.map((p) => p.categoria).toSet().toList();

                  return ListView.builder(
                    itemCount: categorias.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final categoria = categorias[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/platos',
                              arguments: categoria,
                            );
                          },
                          child: Text(
                            categoria,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
