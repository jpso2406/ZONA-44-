import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'dart:math' as Math;

class CustomerFormDialog extends StatefulWidget {
  const CustomerFormDialog({super.key});

  Future<Map<String, String>?> show(BuildContext context) async {
    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final ValueNotifier<String> deliveryType = ValueNotifier<String>('domicilio');
  
  bool isLoading = true;
  bool isAuthenticated = false;
  bool _saveData = false;

  // Estados de validación
  Map<String, String?> _errors = {};
  bool _isFormValid = false;

  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Animación de pulso para el botón
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Controlador para shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    // Listeners para validación en tiempo real
    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    addressController.addListener(_validateForm);
    cityController.addListener(_validateForm);
    deliveryType.addListener(_validateForm);
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token != null && token.isNotEmpty) {
        final user = await UserService().getProfile(token);
        setState(() {
          isAuthenticated = true;
          nameController.text = 
              ((user.firstName ?? '') + ' ' + (user.lastName ?? '')).trim();
          emailController.text = user.email;
          phoneController.text = user.phone ?? '';
          addressController.text = user.address ?? '';
          cityController.text = user.city ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isAuthenticated = false;
          nameController.text = prefs.getString('customer_name') ?? '';
          emailController.text = prefs.getString('customer_email') ?? '';
          phoneController.text = prefs.getString('customer_phone') ?? '';
          addressController.text = prefs.getString('customer_address') ?? '';
          cityController.text = prefs.getString('customer_city') ?? '';
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        isAuthenticated = false;
        isLoading = false;
      });
    }
    _validateForm();
  }

  Future<void> _saveDataToPrefs() async {
    if (_saveData && !isAuthenticated) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('customer_name', nameController.text);
      await prefs.setString('customer_email', emailController.text);
      await prefs.setString('customer_phone', phoneController.text);
      await prefs.setString('customer_address', addressController.text);
      await prefs.setString('customer_city', cityController.text);
    }
  }

  void _validateForm() {
    setState(() {
      _errors.clear();

      if (nameController.text.trim().isEmpty) {
        _errors['name'] = 'El nombre es requerido';
      } else if (nameController.text.trim().length < 3) {
        _errors['name'] = 'Nombre muy corto (mín. 3 caracteres)';
      }

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (emailController.text.trim().isEmpty) {
        _errors['email'] = 'El email es requerido';
      } else if (!emailRegex.hasMatch(emailController.text.trim())) {
        _errors['email'] = 'Email inválido';
      }

      if (phoneController.text.trim().isEmpty) {
        _errors['phone'] = 'El teléfono es requerido';
      } else if (phoneController.text.replaceAll(RegExp(r'[^\d]'), '').length < 7) {
        _errors['phone'] = 'Teléfono inválido (mín. 7 dígitos)';
      }

      if (deliveryType.value == 'domicilio') {
        if (addressController.text.trim().isEmpty) {
          _errors['address'] = 'La dirección es requerida';
        } else if (addressController.text.trim().length < 10) {
          _errors['address'] = 'Dirección muy corta (mín. 10 caracteres)';
        }

        if (cityController.text.trim().isEmpty) {
          _errors['city'] = 'La ciudad es requerida';
        } else if (cityController.text.trim().length < 3) {
          _errors['city'] = 'Ciudad muy corta';
        }
      }

      _isFormValid = _errors.isEmpty;
    });
  }

  void _submit() async {
    if (!_isFormValid) {
      _shakeController.forward(from: 0.0);
      _showShakeAnimation();
      return;
    }

    await _saveDataToPrefs();

    Navigator.pop(context, {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'city': cityController.text.trim(),
      'delivery_type': deliveryType.value,
    });
  }

  void _showShakeAnimation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Por favor corrige los errores antes de continuar',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    deliveryType.dispose();
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFEF8307).withOpacity(0.3),
                blurRadius: 30,
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
                  color: Color(0xFFEF8307).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  color: Color(0xFFEF8307),
                  strokeWidth: 3,
                ).animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.3)),
              ),
              const SizedBox(height: 24),
              Text(
                'Cargando datos...',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEF8307).withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con diseño premium
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEF8307), Color(0xFFD97006)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEF8307).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                    ),
                    child: Icon(
                      Icons.person_pin_circle,
                      color: Colors.white,
                      size: 28,
                    ),
                  ).animate().scale(delay: 200.ms, duration: 400.ms).shimmer(delay: 400.ms, duration: 800.ms),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.customerData,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),
                        Text(
                          'Completa tus datos de entrega',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded, color: Colors.white, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            // Contenido del formulario con scroll
            Flexible(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Color(0xFF0A2E6E).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selector de tipo de entrega con diseño mejorado
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFF040E3F).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Color(0xFFEF8307).withOpacity(0.3), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_shipping_outlined, color: Color(0xFFEF8307), size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppLocalizations.of(context)!.deliveryType,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ValueListenableBuilder<String>(
                                valueListenable: deliveryType,
                                builder: (context, value, _) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: _buildDeliveryOption(
                                          'domicilio',
                                          AppLocalizations.of(context)!.delivery,
                                          Icons.delivery_dining,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildDeliveryOption(
                                          'recoger',
                                          AppLocalizations.of(context)!.pickup,
                                          Icons.store,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),

                        const SizedBox(height: 28),

                        // Campos del formulario
                        _buildTextField(
                          controller: nameController,
                          label: AppLocalizations.of(context)!.name,
                          icon: Icons.person_outline,
                          error: _errors['name'],
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),

                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: emailController,
                          label: AppLocalizations.of(context)!.email,
                          icon: Icons.email_outlined,
                          error: _errors['email'],
                          keyboardType: TextInputType.emailAddress,
                        ).animate().fadeIn(delay: 250.ms).slideX(begin: -0.1, end: 0),

                        const SizedBox(height: 20),

                        _buildTextField(
                          controller: phoneController,
                          label: AppLocalizations.of(context)!.phone,
                          icon: Icons.phone_outlined,
                          error: _errors['phone'],
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),

                        // Campos condicionales con animación
                        ValueListenableBuilder<String>(
                          valueListenable: deliveryType,
                          builder: (context, type, _) {
                            if (type == 'domicilio') {
                              return Column(
                                children: [
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: addressController,
                                    label: 'Dirección de Entrega',
                                    icon: Icons.location_on_outlined,
                                    error: _errors['address'],
                                    maxLines: 2,
                                    textCapitalization: TextCapitalization.sentences,
                                  ).animate().fadeIn().slideY(begin: -0.1, end: 0),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: cityController,
                                    label: 'Ciudad',
                                    icon: Icons.location_city_outlined,
                                    error: _errors['city'],
                                    textCapitalization: TextCapitalization.words,
                                  ).animate().fadeIn(delay: 50.ms).slideY(begin: -0.1, end: 0),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),

                        const SizedBox(height: 20),

                        // Checkbox con diseño mejorado
                        if (!isAuthenticated)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF040E3F).withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.1,
                                  child: Checkbox(
                                    value: _saveData,
                                    onChanged: (value) {
                                      setState(() {
                                        _saveData = value ?? false;
                                      });
                                    },
                                    activeColor: Color(0xFFEF8307),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Guardar mis datos para la próxima vez',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Icon(Icons.bookmark_border, color: Color(0xFFEF8307), size: 20),
                              ],
                            ),
                          ).animate().fadeIn(delay: 400.ms),

                        const SizedBox(height: 28),

                        // Botón con diseño premium y animación
                        AnimatedBuilder(
                          animation: _shakeController,
                          builder: (context, child) {
                            final sineValue = Math.sin(_shakeController.value * 2 * 3.14159 * 3);
                            return Transform.translate(
                              offset: Offset(sineValue * 10, 0),
                              child: child,
                            );
                          },
                          child: ScaleTransition(
                            scale: _isFormValid ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: _isFormValid
                                    ? LinearGradient(
                                        colors: [Color(0xFFEF8307), Color(0xFFD97006)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: _isFormValid ? null : Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: _isFormValid
                                    ? [
                                        BoxShadow(
                                          color: Color(0xFFEF8307).withOpacity(0.5),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: ElevatedButton(
                                onPressed: _isFormValid ? _submit : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rocket_launch_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      AppLocalizations.of(context)!.continueButton,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: Offset(0.8, 0.8), curve: Curves.easeOutBack),
    );
  }

  Widget _buildDeliveryOption(String value, String label, IconData icon) {
    final isSelected = deliveryType.value == value;
    return GestureDetector(
      onTap: () {
        deliveryType.value = value;
        _validateForm();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Color(0xFFEF8307), Color(0xFFD97006)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Color(0xFF040E3F).withOpacity(0.3),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Color(0xFFEF8307) : Colors.white.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFFEF8307).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 30,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ).animate().scaleX(duration: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? error,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final hasError = error != null;
    final hasValue = controller.text.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Color(0xFFEF8307)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: hasError
                  ? [Colors.red.shade900.withOpacity(0.3), Colors.red.shade800.withOpacity(0.2)]
                  : [Color(0xFF040E3F).withOpacity(0.6), Color(0xFF0A2E6E).withOpacity(0.4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError
                  ? Colors.red.shade400
                  : hasValue && !hasError
                      ? Color(0xFFEF8307)
                      : Colors.white.withOpacity(0.2),
              width: hasError ? 2 : 1.5,
            ),
            boxShadow: hasValue && !hasError
                ? [
                    BoxShadow(
                      color: Color(0xFFEF8307).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            textCapitalization: textCapitalization,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasError
                      ? Colors.red.shade400.withOpacity(0.2)
                      : Color(0xFFEF8307).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: hasError ? Colors.red.shade400 : Color(0xFFEF8307),
                  size: 20,
                ),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: hasError
                    ? Icon(Icons.error_rounded, color: Colors.red.shade400, size: 24)
                    : (hasValue && !hasError)
                        ? Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade400.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check_circle_rounded, color: Colors.green.shade400, size: 20),
                          ).animate().scale(duration: 300.ms)
                        : null,
              ),
              hintText: 'Ingresa tu $label',
              hintStyle: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade900.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade400.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.red.shade300, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.red.shade300,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().shake(duration: 400.ms).fadeIn(),
        ],
      ],
    );
  }
}

