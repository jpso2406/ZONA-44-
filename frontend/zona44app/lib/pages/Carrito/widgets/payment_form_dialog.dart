import 'package:flutter/material.dart';

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

        return AlertDialog(
          title: const Text('Pago con tarjeta (Sandbox)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numCtrl,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                ),
              ),
              TextField(
                controller: expCtrl,
                decoration: const InputDecoration(labelText: 'MM/AA'),
              ),
              TextField(
                controller: cvvCtrl,
                decoration: const InputDecoration(labelText: 'CVV'),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre en tarjeta',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop({
                'number': numCtrl.text,
                'exp': expCtrl.text,
                'cvv': cvvCtrl.text,
                'name': nameCtrl.text,
              }),
              child: const Text('Pagar'),
            ),
          ],
        );
      },
    );
  }
}
