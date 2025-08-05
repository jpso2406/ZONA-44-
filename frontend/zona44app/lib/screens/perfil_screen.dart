import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Mi Perfil',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
