import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class PerfiLoading extends StatelessWidget {
  const PerfiLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 670,
        decoration: const BoxDecoration(
          color: Color.fromARGB(240, 4, 14, 63),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.orange,
                backgroundColor: Colors.white24,
                strokeWidth: 5,
              ),
              const SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.loadingProfile,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
