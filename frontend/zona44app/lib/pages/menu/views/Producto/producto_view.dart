import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/pages/menu/bloc/menu_bloc.dart';


class ProductosView extends StatelessWidget {
  final Grupo grupo;
  final List<Producto> productos;

  const ProductosView({
    required this.grupo,
    required this.productos,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  context.read<MenuBloc>().add(GoBackToGrupos());
                },
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  grupo.nombre,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return CardProducto(producto: productos[index]);
            },
          ),
        ),
      ],
    );
  }
}