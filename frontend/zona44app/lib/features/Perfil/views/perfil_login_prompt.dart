import 'package:flutter/material.dart';
import 'package:zona44app/l10n/app_localizations.dart';

/// Widget que muestra un prompt para iniciar sesión
/// Incluye un botón que llama a la función onLogin para navegar a la página de inicio de sesión
class PerfilLoginPrompt extends StatelessWidget {
  final VoidCallback onLogin;

  const PerfilLoginPrompt({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.mustLoginToViewProfile,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 239, 131, 7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.signIn,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
