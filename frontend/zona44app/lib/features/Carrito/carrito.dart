// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/carrito_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/services/user_service.dart';

class Carrito extends StatelessWidget {
  const Carrito({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 670,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF040E3F),
              Color(0xFF0A2E6E),
              Color(0xFF0A2E6E),
            ],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: BlocBuilder<CarritoBloc, CarritoState>(
                builder: (context, state) {
                  if (state is! CarritoLoaded) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFFF6B9D).withOpacity(0.3),
                                  const Color(0xFF8B5CF6).withOpacity(0.3),
                                ],
                              ),
                            ),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Cargando carrito...',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.items.isEmpty) {
                    return CartEmpty();
                  }

                  return Column(
                    children: [
                      _buildItemsCounter(state.items.length),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) => _buildAnimatedItem(
                            index,
                            CartItemCard(
                              producto: state.items[index].producto,
                              cantidad: state.items[index].cantidad,
                              item: state.items[index],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CartSummary(
                          total: state.totalPrecio.toDouble(),
                          onCheckout: () => _handleCheckout(context, state),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B9D), Color(0xFFC06C84)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B9D).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Mi Carrito',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.4),
              ),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.local_fire_department_rounded,
                  color: Color(0xFF10B981),
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'Activo',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsCounter(int count) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inventory_2_rounded,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            '$count ${count == 1 ? 'producto' : 'productos'} en tu carrito',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _handleCheckout(
    BuildContext context,
    CarritoLoaded state,
  ) async {
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
      final customer = await const CustomerFormDialog().show(context);
      if (customer == null) {
        return;
      }

      // Separar delivery_type del resto de los datos del cliente
      final deliveryType = customer['delivery_type'] ?? 'domicilio';
      final customerData = Map<String, dynamic>.from(customer);
      customerData.remove('delivery_type');

      // Mostrar loading mejorado para crear orden
      _showProcessingDialog(
        context,
        title: 'Creando orden...',
        subtitle: 'Preparando tu pedido',
      );

      // Obtener token de autenticación
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');

      // Obtener user_id si está autenticado
      int? userId;
      if (authToken != null && authToken.isNotEmpty) {
        try {
          final user = await UserService().getProfile(authToken);
          userId = user.id;
        } catch (e) {
          print('Error obteniendo perfil del usuario: $e');
        }
      }

      final resp = await const OrderService().createOrder(
        cart: cartPayload,
        totalAmount: state.totalPrecio,
        customer: customerData,
        deliveryType: deliveryType,
        authToken: authToken,
        userId: userId,
      );

      // Cerrar loading de creación
      Navigator.of(context, rootNavigator: true).pop();

      if (resp['success'] == true) {
        final orderId = resp['order_id'];
        
        // Solicitar datos de pago
        final cardData = await const PaymentFormDialog().show(context);

        if (cardData != null) {
          // Mostrar diálogo de procesamiento con PayU
          _showPaymentProcessingDialog(context);

          try {
            // Simular tiempo de verificación de PayU (2-4 segundos realista)
            await Future.delayed(const Duration(milliseconds: 1500));

            final payResp = await const OrderService().payOrder(
              orderId: orderId,
              cardNumber: cardData['number'] ?? '',
              cardExpiration: cardData['exp'] ?? '',
              cardCvv: cardData['cvv'] ?? '',
              cardName: cardData['name'] ?? '',
            );

            // Esperar un poco más para efecto realista de banco
            await Future.delayed(const Duration(milliseconds: 1000));

            // Cerrar diálogo de procesamiento
            Navigator.of(context, rootNavigator: true).pop();

            if (payResp['success'] == true) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const PaymentResultDialog(success: true),
              );
              context.read<CarritoBloc>().add(LimpiarCarrito());
            } else {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => PaymentResultDialog(
                  success: false,
                  message: 'Pago rechazado: ${payResp['error'] ?? 'Error en la transacción'}',
                ),
              );
            }
          } catch (e) {
            // Cerrar diálogo de procesamiento en caso de error
            Navigator.of(context, rootNavigator: true).pop();
            
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => PaymentResultDialog(
                success: false,
                message: 'Error procesando pago: $e',
              ),
            );
          }
        }
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => PaymentResultDialog(
            success: false,
            message: 'Error creando la orden: ${resp['error'] ?? 'Intenta nuevamente'}',
          ),
        );
      }
    } catch (e) {
      // Cerrar cualquier diálogo abierto
      Navigator.of(context, rootNavigator: true).pop();
      
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => PaymentResultDialog(
          success: false,
          message: 'Error creando la orden: $e',
        ),
      );
    }
  }

  void _showProcessingDialog(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1F3A), Color(0xFF0D1117)],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF6B9D).withOpacity(0.3),
                        const Color(0xFF8B5CF6).withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: const CircularProgressIndicator(
                    color: Color(0xFFFF6B9D),
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Container(
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1F3A),
                  Color(0xFF0D1117),
                  Color(0xFF1C2128),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono de PayU/banco procesando
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF10B981).withOpacity(0.3),
                        const Color(0xFF059669).withOpacity(0.3),
                      ],
                    ),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: const [
                      Icon(
                        Icons.credit_card,
                        color: Color(0xFF10B981),
                        size: 40,
                      ),
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          color: Color(0xFF10B981),
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Procesando Pago',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Verificando con PayU...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        color: const Color(0xFF10B981),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Conexión segura',
                        style: TextStyle(
                          color: const Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No cierres esta ventana',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Future<void> _showSuccessSnackBar(BuildContext context, String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color(0xFF10B981).withOpacity(0.3),
          ),
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 2200));
  }
}