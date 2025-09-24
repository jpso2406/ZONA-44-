import 'package:flutter/material.dart';

class ReservaPages extends StatefulWidget {
  @override
  _UserBookingScreenState createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<ReservaPages> {
  final _formKey = GlobalKey<FormState>();
  String nombre = "";
  String telefono = "";
  int personas = 1;

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
                onSaved: (value) => nombre = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Teléfono"),
                onSaved: (value) => telefono = value!,
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Número de personas"),
                onSaved: (value) => personas = int.parse(value!),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Fecha y hora"),
                onSaved: (value) {}, // Aquí podrías usar un DateTime picker
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    
                    // Aquí podrías enviar la info al backend (API)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Reserva guardada para $nombre")),
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
