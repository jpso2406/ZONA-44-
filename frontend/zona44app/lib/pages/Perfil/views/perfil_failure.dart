import 'package:flutter/material.dart';

class PerfilFailure extends StatelessWidget {
  const PerfilFailure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      decoration: BoxDecoration(
        color: Color.fromARGB(240, 4, 14, 63),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          'Error al cargar el perfil',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
