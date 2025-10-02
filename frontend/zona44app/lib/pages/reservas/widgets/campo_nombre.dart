import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoNombre extends StatelessWidget {
  final Function(String) onSaved;

  CampoNombre({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nombre",
        prefixIcon: Icon(Icons.person),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ],
      validator: (value) =>
          value == null || value.isEmpty ? "Ingrese su nombre" : null,
      onSaved: (value) => onSaved(value!),
    );
  }
}
