import 'package:flutter/material.dart';

class CampoFechaHora extends StatelessWidget {
  final DateTime? fechaSeleccionada;
  final Function(DateTime) onFechaSeleccionada;

  CampoFechaHora({
    required this.fechaSeleccionada,
    required this.onFechaSeleccionada,
  });

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        onFechaSeleccionada(
          DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      leading: Icon(Icons.calendar_today,
          color: const Color.fromARGB(255, 10, 8, 84)),
      title: Text(
        fechaSeleccionada == null
            ? "Seleccionar fecha y hora"
            : "${fechaSeleccionada!.day}/${fechaSeleccionada!.month}/${fechaSeleccionada!.year} "
              "${fechaSeleccionada!.hour}:${fechaSeleccionada!.minute.toString().padLeft(2, '0')}",
      ),
      onTap: () => _selectDateTime(context),
    );
  }
}
