import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zona44app/l10n/app_localizations.dart';

// Diálogo para ingresar los datos de la tarjeta de crédito
class PaymentFormDialog extends StatelessWidget {
  const PaymentFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(); // Este widget no se renderiza directamente
  }

  Future<Map<String, String>?> show(BuildContext context) async {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        final numCtrl = TextEditingController(text: '4111111111111111');
        final expCtrl = TextEditingController(text: '12/30');
        final cvvCtrl = TextEditingController(text: '123');
        final nameCtrl = TextEditingController(text: 'APPROVED TEST');

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            Icon(
                                  Icons.credit_card,
                                  size: 48,
                                  color: const Color.fromARGB(255, 239, 131, 7),
                                )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideY(begin: 0.2, end: 0, duration: 400.ms),
                            const SizedBox(height: 10),
                            Text(
                              AppLocalizations.of(context)!.cardPayment,
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: numCtrl,
                              decoration: InputDecoration(
                                labelText: 'Número de tarjeta',
                                labelStyle: GoogleFonts.poppins(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.credit_card),
                              ),
                              keyboardType: TextInputType.number,
                              maxLength: 16,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: expCtrl,
                                    decoration: InputDecoration(
                                      labelText: 'MM/AA',
                                      labelStyle: GoogleFonts.poppins(),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.calendar_today,
                                      ),
                                    ),
                                    keyboardType: TextInputType.datetime,
                                    maxLength: 5,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: cvvCtrl,
                                    decoration: InputDecoration(
                                      labelText: 'CVV',
                                      labelStyle: GoogleFonts.poppins(),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(Icons.lock),
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: nameCtrl,
                              decoration: InputDecoration(
                                labelText: 'Nombre en tarjeta',
                                labelStyle: GoogleFonts.poppins(),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text(
                                    'Cancelar',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () => Navigator.of(ctx).pop({
                                    'number': numCtrl.text,
                                    'exp': expCtrl.text,
                                    'cvv': cvvCtrl.text,
                                    'name': nameCtrl.text,
                                  }),
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Pagar',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 28,
                          ),
                          onPressed: () => Navigator.of(ctx).pop(),
                          tooltip: 'Cerrar',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
