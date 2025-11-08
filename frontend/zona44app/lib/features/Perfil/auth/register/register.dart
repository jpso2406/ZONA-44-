import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/features/Perfil/auth/register/bloc/register_bloc.dart';
import 'package:zona44app/l10n/app_localizations.dart';

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

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    Widget? suffixIcon,
  }) {
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

  /// Muestra un SnackBar profesional con el mensaje de error traducido
  void _showErrorSnackBar(BuildContext context, String errorKey) {
    String message;

    switch (errorKey) {
      case 'email_already_exists':
        message = AppLocalizations.of(context)!.emailAlreadyExists;
        break;
      case 'invalid_credentials':
        message = AppLocalizations.of(context)!.invalidCredentials;
        break;
      case 'network_error':
        message = AppLocalizations.of(context)!.networkError;
        break;
      case 'server_error':
        message = AppLocalizations.of(context)!.serverError;
        break;
      default:
        message = AppLocalizations.of(context)!.registerError;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFD32F2F),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.registerSuccess,
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        } else if (state is RegisterFailure) {
                          _showErrorSnackBar(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.createAccount,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF040E3F),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(
                                  context,
                                )!.completeInfoToContinue,
                                style: TextStyle(color: Colors.black54),
                              ),
                              const SizedBox(height: 28),
                              // Email
                              TextFormField(
                                controller: _emailController,
                                enabled: state is! RegisterLoading,
                                decoration: _inputDecoration(
                                  AppLocalizations.of(context)!.email,
                                  Icons.email,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.requiredField;
                                  }
                                  if (!v.contains("@")) {
                                    return AppLocalizations.of(
                                      context,
                                    )!.enterValidEmail;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              // Password
                              TextFormField(
                                controller: _passwordController,
                                enabled: state is! RegisterLoading,
                                decoration: _inputDecoration(
                                  AppLocalizations.of(context)!.password,
                                  Icons.lock,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFF040E3F),
                                    ),
                                    onPressed: state is RegisterLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                  ),
                                ),
                                obscureText: _obscurePassword,
                                validator: (v) => v == null || v.length < 6
                                    ? AppLocalizations.of(
                                        context,
                                      )!.minimum6Characters
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              // Nombre
                              TextFormField(
                                controller: _firstNameController,
                                enabled: state is! RegisterLoading,
                                decoration: _inputDecoration(
                                  AppLocalizations.of(context)!.firstName,
                                  Icons.person,
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.requiredField
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              // Apellido
                              TextFormField(
                                controller: _lastNameController,
                                enabled: state is! RegisterLoading,
                                decoration: _inputDecoration(
                                  AppLocalizations.of(context)!.lastName,
                                  Icons.person_outline,
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.requiredField
                                    : null,
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
                                    onChanged: state is RegisterLoading
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _selectedCode = value!;
                                            });
                                          },
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phoneController,
                                      enabled: state is! RegisterLoading,
                                      decoration: _inputDecoration(
                                        AppLocalizations.of(context)!.phone,
                                        Icons.phone,
                                      ).copyWith(prefixIcon: null),
                                      keyboardType: TextInputType.number,
                                      validator: (v) {
                                        if (v == null || v.isEmpty) {
                                          return AppLocalizations.of(
                                            context,
                                          )!.requiredField;
                                        }
                                        if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                                          return AppLocalizations.of(
                                            context,
                                          )!.onlyNumbers;
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
                                enabled: state is! RegisterLoading,
                                decoration: _inputDecoration(
                                  AppLocalizations.of(context)!.address,
                                  Icons.home,
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.requiredField
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              // Ciudad
                              TextFormField(
                                controller: _cityController,
                                enabled: state is! RegisterLoading,
                                decoration: _inputDecoration(
                                  AppLocalizations.of(context)!.city,
                                  Icons.location_city,
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.requiredField
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              // Departamento
                              TextFormField(
                                controller: _departmentController,
                                enabled: state is! RegisterLoading,
                                decoration: _inputDecoration(
                                  AppLocalizations.of(context)!.department,
                                  Icons.map_outlined,
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? AppLocalizations.of(
                                        context,
                                      )!.requiredField
                                    : null,
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
                                          backgroundColor: const Color(
                                            0xFFEF8307,
                                          ),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          elevation: 6,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.register,
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
        ),
      ),
    );
  }
}
