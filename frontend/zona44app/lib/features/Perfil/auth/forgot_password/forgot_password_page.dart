import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/features/Perfil/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentStep = 1;
  String _userEmail = '';
  String _userCode = '';

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
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRequestCode() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordBloc>().add(
        RequestPasswordReset(_emailController.text.trim()),
      );
    }
  }

  void _onVerifyCode() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordBloc>().add(
        VerifyResetCode(_userEmail, _codeController.text.trim()),
      );
    }
  }

  void _onResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<ForgotPasswordBloc>().add(
        ResetPassword(_userEmail, _userCode, _passwordController.text.trim()),
      );
    }
  }

  void _goBack() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
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

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: index < _currentStep
                ? const Color(0xFF040E3F)
                : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: index < _currentStep ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.forgotPasswordTitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF040E3F),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.enterEmailToReceiveCode,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 25),
        TextFormField(
          controller: _emailController,
          decoration: _inputDecoration(
            AppLocalizations.of(context)!.email,
            Icons.email,
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return AppLocalizations.of(context)!.requiredField;
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
              return AppLocalizations.of(context)!.enterValidEmail;
            }
            return null;
          },
        ),
        const SizedBox(height: 25),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return state is ForgotPasswordLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onRequestCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF040E3F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.sendCode,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.verifyCode,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF040E3F),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.enterCodeSentTo(_userEmail),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 25),
        TextFormField(
          controller: _codeController,
          decoration: _inputDecoration(
            AppLocalizations.of(context)!.verificationCode,
            Icons.security,
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return AppLocalizations.of(context)!.requiredField;
            }
            if (v.length != 6) {
              return AppLocalizations.of(context)!.codeMustBe6Digits;
            }
            return null;
          },
        ),
        const SizedBox(height: 25),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return state is ForgotPasswordLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onVerifyCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF040E3F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.verifyCode,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.newPassword,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF040E3F),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocalizations.of(context)!.enterNewPassword,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        const SizedBox(height: 25),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.newPassword,
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF040E3F)),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
          validator: (v) {
            if (v == null || v.isEmpty) {
              return AppLocalizations.of(context)!.requiredField;
            }
            if (v.length < 6) {
              return AppLocalizations.of(context)!.minimum6Characters;
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.confirmPassword,
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF040E3F)),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: const Color(0xFF040E3F),
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          obscureText: _obscureConfirmPassword,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return AppLocalizations.of(context)!.requiredField;
            }
            if (v != _passwordController.text) {
              return AppLocalizations.of(context)!.passwordsDoNotMatch;
            }
            return null;
          },
        ),
        const SizedBox(height: 25),
        BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
          builder: (context, state) {
            return state is ForgotPasswordLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF040E3F),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.resetPassword,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ],
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
            icon: const Icon(Icons.arrow_back, color: Color(0xFF040E3F)),
            onPressed: _goBack,
          ),
          title: Text(
            "Recuperar Contraseña",
            style: TextStyle(
              color: Color(0xFF040E3F),
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ForgotPasswordStep1Success) {
                  setState(() {
                    _currentStep = 2;
                    _userEmail = _emailController.text.trim();
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is ForgotPasswordStep2Success) {
                  setState(() {
                    _currentStep = 3;
                    _userCode = _codeController.text.trim();
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is ForgotPasswordStep3Success) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                  Navigator.of(context).pop();
                } else if (state is ForgotPasswordFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.error)));
                }
              },
              child: Center(
                child: SingleChildScrollView(
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
                                _buildStepIndicator(),
                                const SizedBox(height: 30),
                                if (_currentStep == 1) _buildStep1(),
                                if (_currentStep == 2) _buildStep2(),
                                if (_currentStep == 3) _buildStep3(),
                              ],
                            ),
                          ),
                        ),
                      ),
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
