import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/pages/Home/bloc/home_bloc.dart';


class InicioHome extends StatelessWidget {
  const InicioHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 670,
        decoration: BoxDecoration(
          color: Color.fromARGB(240, 4, 14, 63),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Contenido principal (ocupará el espacio disponible)
            Expanded(
              child: Container(), // Aquí puedes agregar contenido futuro
            ),
            // Botones en la parte inferior
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Botón 1: Ir al menú
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(NavigateToMenu());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 239, 131, 7),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'MENÚ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20), // Espacio entre botones
                  // Botón 2: Sección futura
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Aquí irá la lógica para la sección futura
                        print('Navegando a sección futura');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 239, 131, 7),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'SECCIÓN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
