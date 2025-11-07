import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zona44app/features/Home/bloc/home_bloc.dart';
import 'package:zona44app/features/Carrito/bloc/carrito_bloc.dart';

// Barra de navegación inferior para la aplicación
class NavHome extends StatefulWidget {
  const NavHome({super.key});

  @override
  State<NavHome> createState() => _NavHomeState();
}

class _NavHomeState extends State<NavHome> {
  int selectedIndex = 0;

  void _onTap(int index, BuildContext context) {
    setState(() => selectedIndex = index);
    switch (index) {
      case 0:
        context.read<HomeBloc>().add(NavigateToInicio());
        break;
      case 1:
        context.read<HomeBloc>().add(NavigateToCarrito());
        break;
      case 2:
        context.read<HomeBloc>().add(NavigateToPerfil());
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeNavigating) {
          switch (state.destination) {
            case 'inicio':
              setState(() => selectedIndex = 0);
              break;
            case 'carrito':
              setState(() => selectedIndex = 1);
              break;
            case 'perfil':
              setState(() => selectedIndex = 2);
              break;
          }
        }
      },
      child: BlocBuilder<CarritoBloc, CarritoState>(
        builder: (context, carritoState) {
          final cartItemCount = carritoState is CarritoLoaded
              ? carritoState.items.length
              : 0;

          return Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  context,
                  icon: FontAwesomeIcons.houseChimney,
                  label: "Inicio",
                  index: 0,
                  selected: selectedIndex == 0,
                ),
                _navItem(
                  context,
                  icon: FontAwesomeIcons.shoppingCart,
                  label: "Carrito",
                  index: 1,
                  selected: selectedIndex == 1,
                  badgeCount: cartItemCount,
                ),
                _navItem(
                  context,
                  icon: FontAwesomeIcons.circleUser,
                  label: "Perfil",
                  index: 2,
                  selected: selectedIndex == 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool selected,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: () => _onTap(index, context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                color: selected
                    ? const Color.fromARGB(255, 239, 131, 7)
                    : Color.fromARGB(240, 4, 14, 63),
                size: selected ? 28 : 24,
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: selected ? 8 : 0,
                height: 8,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color.fromARGB(255, 239, 131, 7)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          // Badge con contador
          if (badgeCount > 0)
            Positioned(
              top: -2,
              right: -8,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF8307),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF8307).withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    badgeCount > 99 ? '99+' : '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
