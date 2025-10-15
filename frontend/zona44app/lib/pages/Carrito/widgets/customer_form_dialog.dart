import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona44app/services/user_service.dart';

class CustomerFormDialog extends StatefulWidget {
  const CustomerFormDialog({super.key});

  Future<Map<String, String>?> show(BuildContext context) async {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => this,
    );
  }

  @override
  State<CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<CustomerFormDialog> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final ValueNotifier<String> deliveryType = ValueNotifier<String>('domicilio');
  bool isLoading = true;
  bool isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
          isLoading = false;
        });
      } else {
        setState(() {
          isAuthenticated = false;
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        isAuthenticated = false;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    deliveryType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: ValueListenableBuilder<String>(
              valueListenable: deliveryType,
              builder: (context, value, _) {
                return SingleChildScrollView(
                  child:
                      Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_pin_circle,
                                size: 60,
                                color: const Color.fromARGB(255, 239, 131, 7),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Datos del cliente',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tipo de entrega',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: value,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'domicilio',
                                              child: Text('Domicilio'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'recoger',
                                              child: Text(
                                                'Recoger en el local',
                                              ),
                                            ),
                                          ],
                                          onChanged: (val) {
                                            if (val != null)
                                              deliveryType.value = val;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildTextField(
                                controller: nameController,
                                label: 'Nombre',
                                icon: Icons.person,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                controller: emailController,
                                label: 'Email',
                                icon: Icons.email,
                                inputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              _buildTextField(
                                controller: phoneController,
                                label: 'Teléfono',
                                icon: Icons.phone,
                                inputType: TextInputType.phone,
                              ),
                              const SizedBox(height: 28),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, {
                                      'name': nameController.text,
                                      'email': emailController.text,
                                      'phone': phoneController.text,
                                      'delivery_type': deliveryType.value,
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      239,
                                      131,
                                      7,
                                    ),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Text(
                                    'Continuar',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.2, end: 0, duration: 400.ms),
                );
              },
            ),
          ),
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Cerrar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade100,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 239, 131, 7),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
