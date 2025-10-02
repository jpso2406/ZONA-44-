import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoPersonas extends StatelessWidget {
  final Function(int) onSaved;

  CampoPersonas({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Número de personas",
        prefixIcon: Icon(Icons.group),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) =>
          value == null || value.isEmpty ? "Ingrese número de personas" : null,
      onSaved: (value) => onSaved(int.parse(value!)),
    );
  }
}
