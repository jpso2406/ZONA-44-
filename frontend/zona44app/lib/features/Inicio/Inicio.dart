import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/features/Home/bloc/home_bloc.dart';
import 'package:zona44app/features/Reservas/booking_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class InicioHome extends StatelessWidget {
  const InicioHome({super.key});

  // 🔹 Abrir dirección en Google Maps
Future<void> _abrirGoogleMaps() async {
  final Uri url = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=Cra+10+%23+20-30,+Bogotá,+Colombia',
  );

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'No se pudo abrir Google Maps';
  }
}


  // 🔹 Mostrar alerta o abrir chat de ayuda
  void _mostrarAyuda(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.help, color: Color(0xFF0A2E6E)),
            SizedBox(width: 10),
            Text("Centro de ayuda"),
          ],
        ),
        content: const Text(
          "Si necesitas asistencia con tus pedidos o reservas, comunícate con nosotros vía WhatsApp o correo electrónico.\n\n📞 Tel: +57 301 649 7860\n✉️ Email: contacto@zona44.com",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            child: const Text("Cerrar",
                style: TextStyle(color: Color(0xFF0A2E6E))),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 670,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // 🔸 FILA SUPERIOR con botones “Cómo llegar” y “Ayuda”
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botón "Cómo llegar"
                  ElevatedButton.icon(
                    onPressed: _abrirGoogleMaps,
                    icon: const Icon(Icons.location_on, color: Colors.white),
                    label: const Text("cómo llegar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF8307),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Botón "Ayuda"
                  ElevatedButton.icon(
                    onPressed: () => _mostrarAyuda(context),
                    icon: const Icon(Icons.help_outline, color: Colors.white),
                    label: const Text("Ayuda"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF8307),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            const Spacer(),

            // 🔸 Botones inferiores (Menú y Reservar)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Botón MENÚ
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(NavigateToMenu());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF8307),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'MENÚ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Botón RESERVAR
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReservaPages()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF8307),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'RESERVAR',
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
