import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Diálogo para ingresar los datos del cliente
class CustomerFormDialog extends StatelessWidget {
  const CustomerFormDialog({super.key});

  Future<Map<String, String>?> show(BuildContext context) async {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Icon(
                          Icons.person_pin_circle,
                          size: 48,
                          color: const Color.fromARGB(255, 239, 131, 7),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Datos del cliente',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            labelStyle: GoogleFonts.poppins(),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, {
                                  'name': nameController.text,
                                  'email': emailController.text,
                                  'phone': phoneController.text,
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  239,
                                  131,
                                  7,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Continuar',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2, end: 0, duration: 400.ms),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 28),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Cerrar',
            ),
          ),
        ],
      ),
    );
  }
}
