import 'package:flutter/material.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class OrderFailure extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  const OrderFailure({Key? key, this.message, this.onRetry}) : super(key: key);

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
              message ?? AppLocalizations.of(context)!.errorLoadingOrderHistory,
              style: const TextStyle(color: Colors.white, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                AppLocalizations.of(context)!.retry,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
