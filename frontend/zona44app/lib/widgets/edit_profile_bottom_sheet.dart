import 'package:flutter/material.dart';

class EditProfileBottomSheet extends StatelessWidget {
  final String nombre;
  final String email;

  const EditProfileBottomSheet({super.key, required this.nombre, required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Editar perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextFormField(initialValue: nombre, decoration: const InputDecoration(labelText: 'Nombre')),
          TextFormField(initialValue: email, decoration: const InputDecoration(labelText: 'Email')),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado (simulado)')));
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
