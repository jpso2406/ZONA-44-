import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/features/Perfil/auth/register/bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _departmentController = TextEditingController();

  bool _obscurePassword = true;
  String _selectedCode = "+57";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterBloc>().add(
            RegisterSubmitted(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phone: "$_selectedCode${_phoneController.text.trim()}",
              address: _addressController.text.trim(),
              city: _cityController.text.trim(),
              department: _departmentController.text.trim(),
            ),
          );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon,
      {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFEF8307)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registro exitoso')),
                      );
                      Navigator.of(context).pop();
                    } else if (state is RegisterFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Crea tu cuenta",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF040E3F),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Completa la información para continuar",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 28),
                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration(
                              "Correo electrónico",
                              Icons.email,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Campo requerido";
                              }
                              if (!v.contains("@")) {
                                return "Ingrese un correo válido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          // Password
                          TextFormField(
                            controller: _passwordController,
                            decoration: _inputDecoration(
                              "Contraseña",
                              Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF040E3F),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscurePassword,
                            validator: (v) => v == null || v.length < 6
                                ? "Mínimo 6 caracteres"
                                : null,
                          ),
                          const SizedBox(height: 12),
                          // Nombre
                          TextFormField(
                            controller: _firstNameController,
                            decoration:
                                _inputDecoration("Nombre", Icons.person),
                            validator: (v) =>
                                v == null || v.isEmpty ? "Campo requerido" : null,
                          ),
                          const SizedBox(height: 12),
                          // Apellido
                          TextFormField(
                            controller: _lastNameController,
                            decoration: _inputDecoration(
                                "Apellido", Icons.person_outline),
                            validator: (v) =>
                                v == null || v.isEmpty ? "Campo requerido" : null,
                          ),
                          const SizedBox(height: 12),
                          // Teléfono con código país
                          Row(
                            children: [
                              DropdownButton<String>(
                                value: _selectedCode,
                                items: const [
                                  DropdownMenuItem(
                                    value: "+57",
                                    child: Text("+57"),
                                  ),
                                  DropdownMenuItem(
                                    value: "+1",
                                    child: Text("+1"),
                                  ),
                                  DropdownMenuItem(
                                    value: "+34",
                                    child: Text("+34"),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCode = value!;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  decoration: _inputDecoration(
                                    "Teléfono",
                                    Icons.phone,
                                  ).copyWith(prefixIcon: null),
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "Campo requerido";
                                    }
                                    if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                                      return "Solo números";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Dirección
                          TextFormField(
                            controller: _addressController,
                            decoration:
                                _inputDecoration("Dirección", Icons.home),
                            validator: (v) =>
                                v == null || v.isEmpty ? "Campo requerido" : null,
                          ),
                          const SizedBox(height: 12),
                          // Ciudad
                          TextFormField(
                            controller: _cityController,
                            decoration:
                                _inputDecoration("Ciudad", Icons.location_city),
                            validator: (v) =>
                                v == null || v.isEmpty ? "Campo requerido" : null,
                          ),
                          const SizedBox(height: 12),
                          // Departamento
                          TextFormField(
                            controller: _departmentController,
                            decoration: _inputDecoration(
                                "Departamento", Icons.map_outlined),
                            validator: (v) =>
                                v == null || v.isEmpty ? "Campo requerido" : null,
                          ),
                          const SizedBox(height: 28),
                          // Botón
                          state is RegisterLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _onRegister,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF8307),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 6,
                                    ),
                                    child: const Text(
                                      "Registrarse",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
