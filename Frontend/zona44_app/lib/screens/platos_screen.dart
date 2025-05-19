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

            return LayoutBuilder(
              builder: (context, constraints) {
                // Si ancho > 600 (tablet/desktop), usamos GridView con 2 o 3 columnas
                if (constraints.maxWidth > 600) {
                  int crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: platosFiltrados.length,
                    itemBuilder: (context, index) {
                      final plato = platosFiltrados[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plato.nombre,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  plato.descripcion,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text('\$${plato.precio.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  // Para pantallas pequeñas, mostramos lista vertical normal
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: platosFiltrados.length,
                    itemBuilder: (context, index) {
                      final plato = platosFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(plato.nombre),
                          subtitle: Text(plato.descripcion),
                          trailing: Text('\$${plato.precio.toStringAsFixed(2)}'),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
