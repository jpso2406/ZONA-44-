// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/carrito_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/services/user_service.dart';
import 'widgets/order_created_dialog.dart';

class Carrito extends StatelessWidget {
  const Carrito({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 670,
        decoration: BoxDecoration(
          color: Color.fromARGB(240, 4, 14, 63),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: BlocBuilder<CarritoBloc, CarritoState>(
          builder: (context, state) {
            if (state is! CarritoLoaded) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFFEF8307),
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cargando carrito...',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
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
                // Header del carrito
                _buildCartHeader(state.items.length),
                
                // Lista de items
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => CartItemCard(
                      producto: state.items[index].producto,
                      cantidad: state.items[index].cantidad,
                      item: state.items[index],
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Resumen y botón de pago
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
    );
  }

  Widget _buildCartHeader(int itemCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFEF8307),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFEF8307).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi Carrito',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$itemCount ${itemCount == 1 ? 'producto' : 'productos'}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
      // ⭐ NUEVO: Usar el formulario mejorado con validaciones
      final customer = await CustomerFormDialog().show(context);
      if (customer == null) {
        return; // Usuario canceló
      }

      // ⭐ Las validaciones ahora se hacen en tiempo real en el formulario
      // Ya no es necesario validar aquí porque el botón solo se activa si todo es válido

      // Separar delivery_type del resto de los datos del cliente
      final deliveryType = customer['delivery_type'] ?? 'domicilio';
      final customerData = Map<String, dynamic>.from(customer);
      customerData.remove('delivery_type');

      // Mostrar loading mejorado
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _buildLoadingDialog('Creando tu orden...'),
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

      // Cerrar loading
      Navigator.of(context, rootNavigator: true).pop();

      if (resp['success'] == true) {
        final orderId = resp['order_id'];
        final orderNumber = resp['order_number'] ?? 'N/A';

        // Mostrar diálogo de orden creada
        final shouldPay = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => OrderCreatedDialog(
            orderNumber: orderNumber,
            customerEmail: customerData['email'] ?? '',
            isAuthenticated: authToken != null && authToken.isNotEmpty,
            orderItems: state.items,
            totalAmount: state.totalPrecio.toDouble(),
          ),
        );

        // Si el usuario quiere pagar ahora
        if (shouldPay == true) {
          // ⭐ NUEVO: Usar el formulario de pago mejorado
          final cardData = await PaymentFormDialog().show(context);

          if (cardData != null) {
            // ⭐ Las validaciones ahora se hacen en el formulario con algoritmo de Luhn
            // Ya no es necesario validar aquí

            try {
              // Mostrar loading durante el pago con PayU
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => _buildLoadingDialog('Procesando pago con PayU...'),
              );

              final payResp = await const OrderService().payOrder(
                orderId: orderId,
                cardNumber: cardData['number'] ?? '',
                cardExpiration: cardData['exp'] ?? '',
                cardCvv: cardData['cvv'] ?? '',
                cardName: cardData['name'] ?? '',
                authToken: authToken,
              );

              // Cerrar loading del pago
              Navigator.of(context, rootNavigator: true).pop();

              if (payResp['success'] == true) {
                // Mostrar mensaje de éxito
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => _buildSuccessDialog(
                    context,
                    '¡Pago Exitoso!',
                    'Tu pago se ha procesado correctamente.\nNúmero de orden: $orderNumber',
                  ),
                );
                // Vaciar carrito tras pago exitoso
                context.read<CarritoBloc>().add(LimpiarCarrito());
              } else {
                await _showErrorDialog(
                  context,
                  'Pago Rechazado',
                  payResp['error'] ?? 'No se pudo procesar el pago. Por favor intenta nuevamente.',
                );
              }
            } catch (e) {
              // Cerrar loading si hay error
              if (Navigator.canPop(context)) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              
              await _showErrorDialog(
                context,
                'Error en el Pago',
                'Ocurrió un error al procesar tu pago: $e',
              );
            }
          }
        }
      } else {
        await _showErrorDialog(
          context,
          'Error al Crear Orden',
          resp['error'] ?? 'No se pudo crear la orden. Por favor intenta nuevamente.',
        );
      }
    } catch (e) {
      // Cerrar cualquier loading que esté abierto
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      await _showErrorDialog(
        context,
        'Error',
        'Ocurrió un error inesperado: $e',
      );
    }
  }

  // Widget de loading mejorado
  Widget _buildLoadingDialog(String message) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xFF0A2E6E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFEF8307),
              strokeWidth: 4,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo de éxito
  Widget _buildSuccessDialog(BuildContext context, String title, String message) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Color(0xFF0A2E6E),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFEF8307),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF8307),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Aceptar',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Diálogo de error mejorado
  Future<void> _showErrorDialog(BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color(0xFF0A2E6E),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF8307),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Entendido',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}