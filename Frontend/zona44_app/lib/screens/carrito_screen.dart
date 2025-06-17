import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart'; // 📦 Importante para WhatsApp

import '../bloc/carrito_bloc.dart';
import '../bloc/carrito_state.dart';
import '../bloc/carrito_event.dart';
import '../models/carrito_item.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de Compras"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<CarritoBloc, CarritoState>(
        builder: (context, state) {
          if (state is CarritoActualizado) {
            final items = state.items;

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  "Tu carrito está vacío",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            double total = items.fold(
              0,
              (sum, item) => sum + item.plato.precio * item.cantidad,
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return CarritoItemWidget(item: items[index]);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Total: \$${total.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: const Text(
                          "Pagar por WhatsApp",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          _enviarPedidoPorWhatsApp(items, total);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

/// WIDGET INDIVIDUAL PARA CADA PLATO EN EL CARRITO
class CarritoItemWidget extends StatelessWidget {
  final CarritoItem item;

  const CarritoItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(item.plato.imagen ?? 'assets/imagenes/default.png'),
          backgroundColor: Colors.grey[700],
        ),
        title: Text(
          item.plato.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          "Precio: \$${item.plato.precio}",
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
              onPressed: () {
                context.read<CarritoBloc>().add(RemoverDelCarrito(item.plato));
              },
            ),
            Text(
              "${item.cantidad}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.orange),
              onPressed: () {
                context.read<CarritoBloc>().add(AgregarAlCarrito(item.plato));
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// FUNCIÓN PARA ENVIAR EL PEDIDO A WHATSAPP
void _enviarPedidoPorWhatsApp(List<CarritoItem> items, double total) async {
  final telefono = '573001112233'; // ✅ Tu número de WhatsApp en formato internacional sin '+'
  
  final String resumen = items.map((item) =>
      "- ${item.plato.nombre} x${item.cantidad} = \$${(item.plato.precio * item.cantidad).toStringAsFixed(2)}"
    ).join('\n');

  final mensaje = Uri.encodeComponent(
    "¡Hola! Quiero hacer el siguiente pedido desde la app Zona44:\n\n$resumen\n\nTotal: \$${total.toStringAsFixed(2)}"
  );

  final url = "https://wa.me/$telefono?text=$mensaje";

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    debugPrint("No se pudo abrir WhatsApp.");
  }
}
