import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final String email;

  const HomeScreen({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido a Zona 44'),
        backgroundColor: const Color(0xFF0A1128),
      ),
      body: Container(
        color: const Color(0xFFF1F1F1),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $name 👋',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A1128),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Correo: $email',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '¡Gracias por iniciar sesión!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
