import 'package:flutter/material.dart';

class PerfilFailure extends StatelessWidget {
  final String message;
  const PerfilFailure([this.message = 'Error al cargar el perfil', Key? key])
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      decoration: const BoxDecoration(
        color: Color.fromARGB(240, 4, 14, 63),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
