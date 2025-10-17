import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/pages/Perfil/login/bloc/login_bloc.dart';
import 'package:zona44app/pages/Perfil/register/register.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:zona44app/pages/Perfil/register/bloc/register_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona44app/pages/Home/home.dart';
import 'package:zona44app/pages/Home/bloc/home_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  void _onGoogleLogin() {
    context.read<LoginBloc>().add(const GoogleLoginSubmitted());
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF040E3F)),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
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
        child: SafeArea(
          child: Center(
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginSuccess) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('token', state.token);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) => HomeBloc()..add(NavigateToPerfil()),
                        child: const Home(),
                      ),
                    ),
                    (route) => false,
                  );
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Iniciar Sesión",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF040E3F),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: _inputDecoration(
                                    "Correo electrónico",
                                    Icons.email,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) => v == null || v.isEmpty
                                      ? "Campo requerido"
                                      : null,
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: "Contraseña",
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xFF040E3F),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color.fromARGB(
                                          240,
                                          4,
                                          14,
                                          63,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _obscurePassword,
                                  validator: (v) => v == null || v.isEmpty
                                      ? "Campo requerido"
                                      : null,
                                ),

                                const SizedBox(height: 25),
                                state is LoginLoading
                                    ? const CircularProgressIndicator()
                                    : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _onLogin,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF040E3F,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          child: const Text(
                                            "Ingresar",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(height: 20),

                                // Texto "Continuar con"
                                const Center(
                                  child: Text(
                                    "Continuar con",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Botón de Google Sign-In (solo imagen)
                                Center(
                                  child: GestureDetector(
                                    onTap: state is LoginLoading
                                        ? null
                                        : _onGoogleLogin,
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      height: 50,
                                      width: 200,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              height: 50,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xFF4285F4),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Continuar con Google",
                                                  style: TextStyle(
                                                    color: Color(0xFF4285F4),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (_) => RegisterBloc(
                                            userService: UserService(),
                                          ),
                                          child: const RegisterPage(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "¿No tienes cuenta? Regístrate aquí",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF0A2E6E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
