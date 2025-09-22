import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/pages/Home/bloc/home_bloc.dart';

class NavHome extends StatelessWidget {
  const NavHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeNavigating) {
            switch (state.destination) {
              case 'inicio':
                Navigator.pushNamed(context, '/inicio');
                break;
              case 'carrito':
                Navigator.pushNamed(context, '/carrito');
                break;
              case 'perfil':
                Navigator.pushNamed(context, '/perfil');
                break;
            }
          }
        },
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(NavigateToInicio());
                },
                child: Icon(
                  Icons.home,
                  color: const Color.fromARGB(255, 239, 131, 7),
                  size: 30,
                ),
              ),
              SizedBox(width: 40),
              GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(NavigateToCarrito());
                },
                child: Icon(
                  Icons.shopping_cart,
                  color: const Color.fromARGB(255, 239, 131, 7),
                  size: 30,
                ),
              ),
              SizedBox(width: 40),
              GestureDetector(
                onTap: () {
                  context.read<HomeBloc>().add(NavigateToPerfil());
                },
                child: Icon(
                  Icons.person,
                  color: const Color.fromARGB(255, 239, 131, 7),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
