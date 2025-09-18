import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/pages/Home/bloc/home_bloc.dart';



class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              // Contenido principal según el estado
              Expanded(child: _buildContent(state)),
              // Barra de navegación
              NavHome(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(HomeState state) {
    if (state is HomeNavigating) {
      switch (state.destination) {
        case 'inicio':
          return InicioHome();
        case 'carrito':
          return Carrito();
        case 'perfil':
          return Perfil();
        case 'menu': // Agregar este caso
          return Menu();
        default:
          return InicioHome(); // Página por defecto
      }
    }
    return InicioHome(); // Cambiar a InicioHome como página por defecto
  }
}
