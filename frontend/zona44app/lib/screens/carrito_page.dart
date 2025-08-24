import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrito_provider.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);
    final carrito = carritoProvider.carrito;

    return Scaffold(
      appBar: AppBar(title: const Text("Carrito 🛒")),
      body: carrito.isEmpty
          ? const Center(child: Text("Tu carrito está vacío"))
          : ListView.builder(
              itemCount: carrito.length,
              itemBuilder: (context, index) {
                final producto = carrito[index];
                return ListTile(
                  leading: producto.fotoUrl != null
                      ? Image.network(producto.fotoUrl!)
                      : const Icon(Icons.fastfood),
                  title: Text(producto.nombre),
                  subtitle: Text("\$${producto.precio}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      carritoProvider.eliminarProducto(producto);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: carrito.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  carritoProvider.limpiarCarrito();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Compra realizada ✅")),
                  );
                },
                child: const Text(
                  "Finalizar compra",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          : null,
    );
  }
}
