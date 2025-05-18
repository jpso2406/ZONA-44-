import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plato_bloc.dart';
import '../bloc/plato_state.dart';
import '../models/plato.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Zona 44'),
        backgroundColor: Colors.red[700],
      ),
      body: BlocBuilder<PlatoBloc, PlatoState>(
        builder: (context, state) {
          if (state is PlatoCargando) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlatoCargado) {
            return ListView.builder(
              itemCount: state.platos.length,
              itemBuilder: (context, index) {
                final plato = state.platos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(plato.nombre),
                    subtitle: Text(plato.descripcion),
                    trailing: Text('\$${plato.precio.toStringAsFixed(2)}'),
                  ),
                );
              },
            );
          } else if (state is PlatoError) {
            return Center(child: Text(state.mensaje));
          } else {
            return const Center(child: Text('No hay datos.'));
          }
        },
      ),
    );
  }
}