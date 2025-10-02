import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CampoTelefono extends StatelessWidget {
  final Function(String) onSaved;

  CampoTelefono({required this.onSaved});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: "Teléfono",
        prefixIcon: Icon(Icons.phone),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
       keyboardType: TextInputType.phone, // teclado numérico de teléfono
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // solo números
        ],
      initialCountryCode: 'CO', // Código de país inicial (Colombia)
      onChanged: (phone) {
        print(phone.completeNumber); // Ej: +573001234567
            },
      validator: (value) =>
          value == null || value.number.isEmpty ? "Ingrese su teléfono" : null,
      onSaved: (phone) {
        if (phone != null) {
          onSaved(phone.completeNumber);
        }
      },
    );
  }
}
