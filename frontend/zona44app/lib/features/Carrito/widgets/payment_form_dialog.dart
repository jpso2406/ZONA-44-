import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class PaymentFormDialog extends StatefulWidget {
  const PaymentFormDialog({super.key});

  Future<Map<String, String>?> show(BuildContext context) {
    return showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  @override
  State<PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<PaymentFormDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controladores con datos de prueba por defecto
  final _cardNumberController = TextEditingController(text: '4111111111111111');
  final _cardNameController = TextEditingController(text: 'APPROVED TEST');
  final _expirationController = TextEditingController(text: '12/30');
  final _cvvController = TextEditingController(text: '123');

  Map<String, String?> _errors = {};
  bool _isFormValid = false;
  String _cardType = 'visa'; // Ya detecta Visa por el número de prueba

  @override
  void initState() {
    super.initState();

    // Listeners para validación en tiempo real
    _cardNumberController.addListener(() {
      _detectCardType();
      _validateForm();
    });
    _cardNameController.addListener(_validateForm);
    _expirationController.addListener(_validateForm);
    _cvvController.addListener(_validateForm);

    // Detectar tipo de tarjeta inicial
    _detectCardType();
    // No validar aquí porque AppLocalizations aún no está disponible
    // La validación se ejecutará automáticamente cuando el widget se construya
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Validar una vez que las dependencias estén listas
    _validateForm();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expirationController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _detectCardType() {
    final number = _cardNumberController.text.replaceAll(' ', '');
    setState(() {
      if (number.startsWith('4')) {
        _cardType = 'visa';
      } else if (number.startsWith(RegExp(r'^5[1-5]'))) {
        _cardType = 'mastercard';
      } else if (number.startsWith(RegExp(r'^3[47]'))) {
        _cardType = 'amex';
      } else if (number.isEmpty) {
        _cardType = 'unknown';
      } else {
        _cardType = 'generic';
      }
    });
  }

  void _validateForm() {
    setState(() {
      _errors.clear();

      final localizations = AppLocalizations.of(context)!;

      // Validar número de tarjeta
      final cardNumber = _cardNumberController.text.replaceAll(' ', '');
      if (cardNumber.isEmpty) {
        _errors['number'] = localizations.cardNumberRequired;
      } else if (cardNumber.length < 13 || cardNumber.length > 19) {
        _errors['number'] = localizations.invalidCardNumber;
      } else if (!_luhnCheck(cardNumber)) {
        _errors['number'] = localizations.invalidCardChecksum;
      }

      // Validar nombre
      if (_cardNameController.text.trim().isEmpty) {
        _errors['name'] = localizations.nameRequired;
      } else if (_cardNameController.text.trim().length < 3) {
        _errors['name'] = localizations.nameTooShort;
      } else if (!RegExp(
        r'^[a-zA-Z\s]+$',
      ).hasMatch(_cardNameController.text.trim())) {
        _errors['name'] = localizations.onlyLettersAndSpaces;
      }

      // Validar fecha de expiración
      final expRegex = RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$');
      if (_expirationController.text.isEmpty) {
        _errors['exp'] = localizations.expiryDateRequired;
      } else if (!expRegex.hasMatch(_expirationController.text)) {
        _errors['exp'] = localizations.invalidExpiryFormat;
      } else {
        // Validar que no esté vencida
        final parts = _expirationController.text.split('/');
        final month = int.parse(parts[0]);
        final year = int.parse('20${parts[1]}');
        final now = DateTime.now();
        final expDate = DateTime(year, month);

        if (expDate.isBefore(DateTime(now.year, now.month))) {
          _errors['exp'] = localizations.cardExpired;
        }
      }

      // Validar CVV
      if (_cvvController.text.isEmpty) {
        _errors['cvv'] = localizations.cvvRequired;
      } else if (_cardType == 'amex' && _cvvController.text.length != 4) {
        _errors['cvv'] = localizations.cvvAmexLength;
      } else if (_cardType != 'amex' && _cvvController.text.length != 3) {
        _errors['cvv'] = localizations.cvvLength;
      }

      _isFormValid = _errors.isEmpty;
    });
  }

  // Algoritmo de Luhn para validar número de tarjeta
  bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  void _submit() {
    if (!_isFormValid) {
      _showShakeAnimation();
      return;
    }

    Navigator.of(context).pop({
      'number': _cardNumberController.text.replaceAll(' ', ''),
      'name': _cardNameController.text.trim().toUpperCase(),
      'exp': _expirationController.text,
      'cvv': _cvvController.text,
    });
  }

  void _showShakeAnimation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.fixErrorsBeforeContinue,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF0A2E6E),
          borderRadius: BorderRadius.circular(20),
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFEF8307),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        Icon(Icons.credit_card, color: Colors.white, size: 24)
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: Offset(0.8, 0.8)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.cardPayment,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.securePaymentWith,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Contenido del formulario
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vista previa de la tarjeta
                      _buildCardPreview(),

                      const SizedBox(height: 24),

                      // Número de tarjeta
                      _buildTextField(
                        controller: _cardNumberController,
                        label: AppLocalizations.of(context)!.cardNumber,
                        icon: Icons.credit_card,
                        error: _errors['number'],
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(19),
                          _CardNumberFormatter(),
                        ],
                        suffixIcon: _buildCardTypeIcon(),
                      ),

                      const SizedBox(height: 16),

                      // Nombre en la tarjeta
                      _buildTextField(
                        controller: _cardNameController,
                        label: AppLocalizations.of(context)!.cardholderName,
                        icon: Icons.person_outline,
                        error: _errors['name'],
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Fecha de expiración y CVV
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _expirationController,
                              label: AppLocalizations.of(context)!.expiryDate,
                              icon: Icons.calendar_today,
                              error: _errors['exp'],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                _ExpirationDateFormatter(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _cvvController,
                              label: AppLocalizations.of(context)!.cvv,
                              icon: Icons.lock_outline,
                              error: _errors['cvv'],
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                  _cardType == 'amex' ? 4 : 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Mensaje de seguridad
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF040E3F),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.security,
                              color: Color(0xFFEF8307),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.sslProtection,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botón de pagar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isFormValid ? _submit : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid
                                ? Color(0xFFEF8307)
                                : Colors.grey.shade600,
                            disabledBackgroundColor: Colors.grey.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: _isFormValid ? 4 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.pay,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 300.ms).scale(begin: Offset(0.9, 0.9)),
      ),
    );
  }

  Widget _buildCardPreview() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEF8307), Color(0xFFD97006)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEF8307).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ZONA 44',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                _buildCardTypeIcon(size: 40, onCard: true),
              ],
            ),
            Text(
              _cardNumberController.text.isEmpty
                  ? '•••• •••• •••• ••••'
                  : _cardNumberController.text,
              style: GoogleFonts.courierPrime(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.cardholder,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      _cardNameController.text.isEmpty
                          ? AppLocalizations.of(context)!.cardholderPlaceholder
                          : _cardNameController.text.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.expires,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      _expirationController.text.isEmpty
                          ? AppLocalizations.of(context)!.expiryPlaceholder
                          : _expirationController.text,
                      style: GoogleFonts.courierPrime(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTypeIcon({double size = 24, bool onCard = false}) {
    Color color = onCard ? Colors.white : Color(0xFFEF8307);

    switch (_cardType) {
      case 'visa':
      case 'mastercard':
      case 'amex':
        return Icon(Icons.credit_card, size: size, color: color);
      default:
        return Icon(Icons.credit_card_outlined, size: size, color: color);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? error,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? suffixIcon,
  }) {
    final hasError = error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF040E3F),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? Colors.red.shade400 : Colors.white24,
              width: hasError ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            obscureText: obscureText,
            textCapitalization: textCapitalization,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: hasError ? Colors.red.shade400 : Color(0xFFEF8307),
                size: 22,
              ),
              suffixIcon:
                  suffixIcon ??
                  (hasError
                      ? Icon(
                          Icons.error_outline,
                          color: Colors.red.shade400,
                          size: 22,
                        )
                      : (controller.text.isNotEmpty && !hasError)
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.green.shade400,
                          size: 22,
                        )
                      : null),
              hintText: AppLocalizations.of(context)!.enterField(label),
              hintStyle: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade400, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  error,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// Formateador para número de tarjeta (agregar espacios cada 4 dígitos)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

// Formateador para fecha de expiración (MM/AA)
class _ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length >= 2 && !text.contains('/')) {
      return TextEditingValue(
        text: '${text.substring(0, 2)}/${text.substring(2)}',
        selection: TextSelection.collapsed(offset: text.length + 1),
      );
    }

    return newValue;
  }
}
