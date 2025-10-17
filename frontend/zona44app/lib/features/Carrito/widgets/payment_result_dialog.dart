// Animación de resultado de pago
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PaymentResultDialog extends StatelessWidget {
  final bool success;
  final String? message;
  const PaymentResultDialog({required this.success, this.message});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: success
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Animate(
              effects: success
                  ? [
                      ScaleEffect(
                        curve: Curves.elasticOut,
                        duration: 600.ms,
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.2, 1.2),
                      ),
                      FadeEffect(duration: 400.ms),
                      ShimmerEffect(
                        duration: 1200.ms,
                        color: Colors.greenAccent,
                      ),
                    ]
                  : [
                      ShakeEffect(
                        duration: 700.ms,
                        hz: 4,
                        offset: const Offset(8, 0),
                      ),
                      FadeEffect(duration: 400.ms),
                    ],
              child: Icon(
                success ? Icons.check_circle : Icons.cancel,
                color: success ? Colors.green : Colors.red,
                size: 80,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              success ? '¡Pago exitoso!' : 'Ocurrió un error',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: success ? Colors.green : Colors.red,
              ),
            ).animate().fade(duration: 400.ms),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ).animate().fade(duration: 400.ms),
            ],
          ],
        ),
      ),
    );
  }
}
