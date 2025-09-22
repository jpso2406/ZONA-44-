import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Widget para mostrar cuando el carrito está vacío
class CartEmpty extends StatelessWidget {
  const CartEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.white.withOpacity(0.7),
              )
              .animate()
              .fade(duration: 500.ms)
              .scale(duration: 700.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            '¡Tu carrito está vacío!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fade(duration: 500.ms),
          const SizedBox(height: 12),
          Text(
            'Agrega productos y disfruta de la mejor experiencia',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ).animate().fade(duration: 700.ms),
        ],
      ),
    );
  }
}
