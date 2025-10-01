import 'package:flutter/material.dart';

class BotonConfirmar extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final DateTime? fechaHoraSeleccionada;
  final VoidCallback onConfirmar;

  BotonConfirmar({
    required this.formKey,
    required this.fechaHoraSeleccionada,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 8, 12, 88),
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState!.save();

          if (fechaHoraSeleccionada == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Por favor selecciona fecha y hora")),
            );
            return;
          }

          onConfirmar();
        }
      },
      child: Text(
        "Confirmar Reserva",
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
