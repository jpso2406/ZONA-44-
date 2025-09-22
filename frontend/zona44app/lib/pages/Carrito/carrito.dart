import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/carrito_bloc.dart';
import '../../services/order_service.dart';

class Carrito extends StatelessWidget {
  const Carrito({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 670,
      decoration: BoxDecoration(
        color: const Color.fromARGB(240, 4, 14, 63),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<CarritoBloc, CarritoState>(
          builder: (context, state) {
            if (state is! CarritoLoaded) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final items = state.items;
            final total = state.totalPrecio;

            if (items.isEmpty) {
              return const Center(
                child: Text(
                  'Tu carrito está vacío',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.producto.fotoUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) =>
                                    const Icon(Icons.fastfood, size: 60),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.producto.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${item.producto.precio}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final newQty = item.cantidad - 1;
                                    context.read<CarritoBloc>().add(
                                      ActualizarCantidad(
                                        item.producto.id,
                                        newQty,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('${item.cantidad}'),
                                IconButton(
                                  onPressed: () {
                                    context.read<CarritoBloc>().add(
                                      AgregarProducto(item.producto),
                                    );
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<CarritoBloc>().add(
                                      RemoverProducto(item.producto.id),
                                    );
                                  },
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${total}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 239, 131, 7),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () =>
                            context.read<CarritoBloc>().add(LimpiarCarrito()),
                        child: const Text('Vaciar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final state = context.read<CarritoBloc>().state;
                          if (state is! CarritoLoaded) return;

                          final cartPayload = state.items
                              .map(
                                (it) => {
                                  'producto_id': it.producto.id,
                                  'cantidad': it.cantidad,
                                  'unit_price': it.producto.precio,
                                },
                              )
                              .toList();

                          try {
                            // Datos del cliente (opcional)
                            final customer =
                                await showDialog<Map<String, String>>(
                                  context: context,
                                  builder: (ctx) {
                                    final nameCtrl = TextEditingController();
                                    final emailCtrl = TextEditingController();
                                    final phoneCtrl = TextEditingController();
                                    return AlertDialog(
                                      title: const Text('Datos del cliente'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: nameCtrl,
                                            decoration: const InputDecoration(
                                              labelText: 'Nombre',
                                            ),
                                          ),
                                          TextField(
                                            controller: emailCtrl,
                                            decoration: const InputDecoration(
                                              labelText: 'Email',
                                            ),
                                          ),
                                          TextField(
                                            controller: phoneCtrl,
                                            decoration: const InputDecoration(
                                              labelText: 'Teléfono',
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(),
                                          child: const Text('Omitir'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop({
                                                'name': nameCtrl.text,
                                                'email': emailCtrl.text,
                                                'phone': phoneCtrl.text,
                                              }),
                                          child: const Text('Continuar'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                            final resp = await const OrderService().createOrder(
                              cart: cartPayload,
                              totalAmount: state.totalPrecio,
                              customer: customer,
                            );
                            if (resp['success'] == true) {
                              final orderId = resp['order_id'];
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Orden #$orderId creada'),
                                ),
                              );
                              // Solicitar datos de tarjeta sandbox y pagar
                              final cardData =
                                  await showDialog<Map<String, String>>(
                                    context: context,
                                    builder: (ctx) {
                                      final numCtrl = TextEditingController(
                                        text: '4111111111111111',
                                      );
                                      final expCtrl = TextEditingController(
                                        text: '12/30',
                                      );
                                      final cvvCtrl = TextEditingController(
                                        text: '123',
                                      );
                                      final nameCtrl = TextEditingController(
                                        text: 'APPROVED TEST',
                                      );
                                      return AlertDialog(
                                        title: const Text(
                                          'Pago con tarjeta (Sandbox)',
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: numCtrl,
                                              decoration: const InputDecoration(
                                                labelText: 'Número de tarjeta',
                                              ),
                                            ),
                                            TextField(
                                              controller: expCtrl,
                                              decoration: const InputDecoration(
                                                labelText: 'MM/AA',
                                              ),
                                            ),
                                            TextField(
                                              controller: cvvCtrl,
                                              decoration: const InputDecoration(
                                                labelText: 'CVV',
                                              ),
                                            ),
                                            TextField(
                                              controller: nameCtrl,
                                              decoration: const InputDecoration(
                                                labelText: 'Nombre en tarjeta',
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: const Text('Cancelar'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop({
                                                  'number': numCtrl.text,
                                                  'exp': expCtrl.text,
                                                  'cvv': cvvCtrl.text,
                                                  'name': nameCtrl.text,
                                                }),
                                            child: const Text('Pagar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                              if (cardData != null) {
                                try {
                                  final payResp = await const OrderService()
                                      .payOrder(
                                        orderId: orderId,
                                        cardNumber: cardData['number'] ?? '',
                                        cardExpiration: cardData['exp'] ?? '',
                                        cardCvv: cardData['cvv'] ?? '',
                                        cardName: cardData['name'] ?? '',
                                      );

                                  if (payResp['success'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pago aprobado'),
                                      ),
                                    );
                                    // Vaciar carrito tras pago exitoso
                                    // ignore: use_build_context_synchronously
                                    context.read<CarritoBloc>().add(
                                      LimpiarCarrito(),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Pago rechazado: ${payResp['error'] ?? ''}',
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error procesando pago: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error: ${resp['errors'] ?? 'No se pudo crear la orden'}',
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error creando la orden: $e'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            239,
                            131,
                            7,
                          ),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Pagar'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
