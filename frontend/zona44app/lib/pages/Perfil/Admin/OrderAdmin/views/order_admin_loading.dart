import 'package:flutter/material.dart';

/// Vista que muestra un indicador de carga mientras se obtienen las órdenes
/// Usada en OrderAdminPage cuando el estado es OrderAdminLoading
/// 
class OrderAdminLoading extends StatelessWidget {
  const OrderAdminLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      decoration: const BoxDecoration(
        // color: Color.fromARGB(240, 4, 14, 63),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 239, 131, 7),
          strokeWidth: 5,
        ),
      ),
    );
  }
}
