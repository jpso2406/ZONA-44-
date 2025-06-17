import 'package:flutter/material.dart';
import '../models/plato.dart';

class CarritoItemWidget extends StatelessWidget {
  final Plato plato;
  final int cantidad;
  final VoidCallback? onEliminar;

  const CarritoItemWidget({
    super.key,
    required this.plato,
    required this.cantidad,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final imagen = plato.imagen;

    final Widget imagenWidget = (imagen != null && imagen.startsWith('http'))
        ? Image.network(imagen, width: 80, height: 80, fit: BoxFit.cover)
        : Image.asset(
            imagen ?? 'assets/images/default.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );

    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imagenWidget,
        ),
        title: Text(
          plato.nombre,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Cantidad: $cantidad\nPrecio: \$${plato.precio.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.orangeAccent),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: onEliminar,
        ),
      ),
    );
  }
}
