import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/carrito_bloc.dart';

class CartSummary extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;

  const CartSummary({required this.total, required this.onCheckout, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total a pagar:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                '\$$total',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 239, 131, 7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  context.read<CarritoBloc>().add(LimpiarCarrito());
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Vaciar carrito'),
                style: TextButton.styleFrom(
                  foregroundColor: Color.fromARGB(255, 239, 131, 7),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onCheckout,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('Proceder al pago'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 239, 131, 7),
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
    );
  }
}
