import 'package:flutter/material.dart';

class PromocionesPage extends StatelessWidget {
  const PromocionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Promociones"),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.local_offer, color: Colors.redAccent),
              title: Text("Promo 2x1 en hamburguesas"),
              subtitle: Text("Solo por tiempo limitado"),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.local_offer, color: Colors.redAccent),
              title: Text("Bebida gratis con tu combo"),
              subtitle: Text("Todos los viernes"),
            ),
          ),
        ],
      ),
    );
  }
}
