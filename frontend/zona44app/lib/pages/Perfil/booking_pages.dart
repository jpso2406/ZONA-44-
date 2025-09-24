import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReservaPages extends StatefulWidget {
  @override
  _UserBookingScreenState createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<ReservaPages> {
  final _formKey = GlobalKey<FormState>();
  String nombre = "";
  String telefono = "";
  int personas = 1;

  DateTime? fechaHoraSeleccionada; // 👈 variable para guardar fecha y hora

  // Método para seleccionar fecha
  Future<void> _selectDateTime(BuildContext context) async {
    // Primero selecciona la fecha
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Luego selecciona la hora
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          fechaHoraSeleccionada = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reservar Mesa")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Nombre"),
                inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), 
                // 👆 solo letras mayúsculas, minúsculas y espacios
                  ],
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      nombre = value; // siempre será String
                    }
                  },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // solo dígitos
                  ],
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      personas = int.parse(value);
                    }
                  },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Número de personas"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // solo dígitos
                  ],
                  onSaved: (value) {
                    if (value != null && value.isNotEmpty) {
                      personas = int.parse(value);
                    }
                  },
              ),

              // 👉 Aquí va el campo de fecha y hora
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                  fechaHoraSeleccionada == null
                      ? "Seleccionar fecha y hora"
                      : "${fechaHoraSeleccionada!.day}/${fechaHoraSeleccionada!.month}/${fechaHoraSeleccionada!.year} "
                        "${fechaHoraSeleccionada!.hour}:${fechaHoraSeleccionada!.minute.toString().padLeft(2, '0')}",
                ),
                onTap: () => _selectDateTime(context),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (fechaHoraSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Por favor selecciona fecha y hora")),
                      );
                      return;
                    }

                    // Aquí podrías enviar la info al backend (API)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Reserva guardada para $nombre el ${fechaHoraSeleccionada.toString()}",
                        ),
                      ),
                    );

                    Navigator.pop(context); // Regresa a la pantalla anterior
                  }
                },
                child: Text("Confirmar Reserva"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
