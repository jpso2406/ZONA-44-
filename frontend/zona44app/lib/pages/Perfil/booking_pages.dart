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

  // Método para seleccionar fecha y hora
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

  void _mostrarAlertaReserva() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("¡Reserva confirmada!"),
            ],
          ),
          content: Text(
            "Tu reserva se realizó con éxito para el día "
            "${fechaHoraSeleccionada!.day}/${fechaHoraSeleccionada!.month}/${fechaHoraSeleccionada!.year} "
            "a las ${fechaHoraSeleccionada!.hour}:${fechaHoraSeleccionada!.minute.toString().padLeft(2, '0')}.",
          ),
          actions: [
            TextButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pop(context); // Vuelve a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reservar Mesa"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        backgroundColor: const Color.fromARGB(240, 4, 14, 63),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo Nombre
              TextFormField(
                decoration: _buildInputDecoration("Nombre", Icons.person),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese su nombre" : null,
                onSaved: (value) => nombre = value!,
              ),
              SizedBox(height: 15),

              // Campo Teléfono
              TextFormField(
                decoration: _buildInputDecoration("Teléfono", Icons.phone),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese su teléfono" : null,
                onSaved: (value) => telefono = value!,
              ),
              SizedBox(height: 15),

              // Campo Número de personas
              TextFormField(
                decoration: _buildInputDecoration(
                    "Número de personas", Icons.group),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese número de personas" : null,
                onSaved: (value) => personas = int.parse(value!),
              ),
              SizedBox(height: 15),

              // Campo Fecha y hora
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                leading: Icon(Icons.calendar_today, color: const Color.fromARGB(255, 10, 8, 84)),
                title: Text(
                  fechaHoraSeleccionada == null
                      ? "Seleccionar fecha y hora"
                      : "${fechaHoraSeleccionada!.day}/${fechaHoraSeleccionada!.month}/${fechaHoraSeleccionada!.year} "
                        "${fechaHoraSeleccionada!.hour}:${fechaHoraSeleccionada!.minute.toString().padLeft(2, '0')}",
                ),
                onTap: () => _selectDateTime(context),
              ),
              SizedBox(height: 25),

              // Botón Confirmar
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 8, 12, 88),
                  padding:
                      EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (fechaHoraSeleccionada == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("Por favor selecciona fecha y hora")),
                      );
                      return;
                    }

                    // Mostrar alerta de confirmación
                    _mostrarAlertaReserva();
                  }
                },
                child: Text(
                  "Confirmar Reserva",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
