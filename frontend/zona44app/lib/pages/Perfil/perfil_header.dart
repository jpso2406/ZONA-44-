import 'package:flutter/material.dart';

class PerfilHeader extends StatelessWidget {
  final String nombre;
  final String email;
  final Color primary;
  final VoidCallback onAvatarTap;
  final VoidCallback onEditProfile;

  const PerfilHeader({
    super.key,
    required this.nombre,
    required this.email,
    required this.primary,
    required this.onAvatarTap,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar con borde degradado
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFFFF9800)]),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: GestureDetector(
            onTap: onAvatarTap,
            child: const CircleAvatar(
              radius: 56,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 56, color: Color.fromARGB(240, 4, 14, 63)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(nombre, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: onEditProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 4,
          ),
          icon: const Icon(Icons.edit),
          label: const Text('Editar perfil'),
        ),
      ],
    );
  }
}
