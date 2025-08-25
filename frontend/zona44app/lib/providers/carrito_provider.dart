import 'package:flutter/material.dart';
import '../screens/inicio_page.dart'; // para usar la clase Producto

class CarritoProvider extends ChangeNotifier {
  final List<Producto> _carrito = [];

  List<Producto> get carrito => _carrito;

  void agregarProducto(Producto producto) {
    _carrito.add(producto);
    notifyListeners();
  }

  void eliminarProducto(Producto producto) {
    _carrito.remove(producto);
    notifyListeners();
  }

  void limpiarCarrito() {
    _carrito.clear();
    notifyListeners();
  }
}
