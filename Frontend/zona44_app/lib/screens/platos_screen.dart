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
      appBar: AppBar(title: Text('Platos de $categoria')),
      body: BlocBuilder<PlatoBloc, PlatoState>(
        builder: (context, state) {
          if (state is PlatoCargado) {
            final platosFiltrados = state.platos.where((p) => p.categoria == categoria).toList();

            if (platosFiltrados.isEmpty) {
              return Center(child: Text('No hay platos disponibles para esta categoría.'));
            }

            return ListView.builder(
              itemCount: platosFiltrados.length,
              itemBuilder: (context, index) {
                final plato = platosFiltrados[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    title: Text(plato.nombre),
                    subtitle: Text(plato.descripcion ?? 'Sin descripción'),
                    trailing: Text('\$${plato.precio.toStringAsFixed(2)}'),
                  ),
                );
              },
            );
          } else if (state is PlatoError) {
            return Center(child: Text(state.mensaje));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
