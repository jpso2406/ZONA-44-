import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class ReservationsTabs extends StatelessWidget {
  final bool showMyReservations;
  final ValueChanged<bool> onTabChanged;

  const ReservationsTabs({
    super.key,
    required this.showMyReservations,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !showMyReservations
                      ? const Color(0xFFEF8307)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.makeReservation,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: !showMyReservations
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: showMyReservations
                      ? const Color(0xFFEF8307)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.myReservations,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: showMyReservations
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
