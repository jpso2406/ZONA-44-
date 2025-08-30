import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/menu_bloc.dart';
import 'views/Grupo/grupo_view.dart';
import 'views/Producto/producto_view.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(LoadMenu()),
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return Container(
            height: 670,
            decoration: BoxDecoration(
              color: Color.fromARGB(240, 4, 14, 63),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MenuState state) {
    if (state is MenuLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.white));
    } else if (state is GruposLoaded) {
      return GruposView(grupos: state.grupos);
    } else if (state is ProductosLoaded) {
      return ProductosView(
        grupo: state.grupo,
        productos: state.productos,
      );
    } else if (state is MenuError) {
      return _buildErrorView(context, state.message);
    }
    return Container();
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Error: $message',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<MenuBloc>().add(LoadMenu());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 239, 131, 7),
              foregroundColor: Colors.white,
            ),
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}