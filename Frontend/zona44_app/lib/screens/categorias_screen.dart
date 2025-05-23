import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plato_bloc.dart';
import '../bloc/plato_state.dart';

class CategoriasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú')),
      body: BlocBuilder<PlatoBloc, PlatoState>(
        builder: (context, state) {
          if (state is PlatoCargando) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlatoCargado) {
            final categorias = state.platos.map((p) => p.categoria).toSet().toList();

            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/platos',
                        arguments: categoria,
                      );
                    },
                    child: Text(categoria, style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            );
          } else if (state is PlatoError) {
            return Center(child: Text(state.mensaje));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
