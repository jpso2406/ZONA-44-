import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zona44app/features/Home/bloc/home_bloc.dart';
import 'package:zona44app/features/Reservas/booking_pages.dart';
import 'package:zona44app/widgets/language_selector.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zona44app/features/OrderTracking/order_tracking_page.dart';

class InicioHome extends StatelessWidget {
  const InicioHome({super.key});

  // 🔹 Abrir dirección en Google Maps
  Future<void> _abrirGoogleMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Cra+10+%23+20-30,+Bogotá,+Colombia',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
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
          children: [
            const Icon(Icons.help, color: Color(0xFF0A2E6E)),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.helpCenter),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.helpMessage,
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            child: Text(
              AppLocalizations.of(context)!.close,
              style: const TextStyle(color: Color(0xFF0A2E6E)),
            ),
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
            // 🔸 HEADER con controles pegados y botón de seguimiento a la derecha
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Grupo de controles pegados a la izquierda
                  Row(
                    children: [
                      // Selector de idioma con bandera circular
                      const LanguageSelector(),

                      const SizedBox(width: 4),

                      // Icono "Ayuda"
                      IconButton(
                        onPressed: () => _mostrarAyuda(context),
                        icon: const FaIcon(
                          FontAwesomeIcons.headset,
                          color: Colors.white,
                          size: 24,
                        ),
                        tooltip: AppLocalizations.of(context)!.help,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                      const SizedBox(width: 4),

                      // Icono "Cómo llegar"
                      IconButton(
                        onPressed: _abrirGoogleMaps,
                        icon: const FaIcon(
                          FontAwesomeIcons.mapLocationDot,
                          color: Colors.white,
                          size: 24,
                        ),
                        tooltip: AppLocalizations.of(context)!.howToGetThere,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  // Botón "Seguir Pedido" pegado a la derecha
                  // Botón "Seguir Pedido" pegado a la derecha
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const OrderTrackingPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: const Text(
                      'Seguir',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A2E6E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 Animación Lottie en el centro
            Expanded(
              child: Center(
                child: Lottie.asset(
                  'assets/animations/home.json',
                  width: 450,
                  height: 450,
                  fit: BoxFit.contain,
                ),
              ),
            ),

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
                      child: Text(
                        AppLocalizations.of(context)!.menu,
                        style: const TextStyle(
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
                            builder: (context) => ReservaPages(),
                          ),
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
                      child: Text(
                        AppLocalizations.of(context)!.reserve,
                        style: const TextStyle(
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
