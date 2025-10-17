import 'package:flutter/material.dart';
import 'package:zona44app/features/Perfil/views/perfil_success.dart';
import 'package:zona44app/features/Perfil/auth/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:zona44app/features/Perfil/bloc/perfil_bloc.dart';

import 'auth/login/bloc/login_bloc.dart';
import 'views/perfil_failure.dart';
import 'views/perfil_loading.dart';
import 'views/perfil_login_prompt.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  bool _isLoggedIn = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getString('token') != null;
      _loading = false;
    });
  }

  void _goToLogin() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => LoginBloc(userService: UserService()),
          child: const LoginPage(),
        ),
      ),
    );
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const PerfiLoading();
    }
    if (!_isLoggedIn) {
      return PerfilLoginPrompt(onLogin: _goToLogin);
    }
    // Usar el Bloc para mostrar el perfil real
    return BlocProvider(
      create: (_) => PerfilBloc()..add(PerfilLoadRequested()),
      child: const PerfilBlocView(),
    );
  }
}

class PerfilBlocView extends StatelessWidget {
  const PerfilBlocView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerfilBloc, PerfilState>(
      builder: (context, state) {
        if (state is PerfilLoadingState) {
          return const PerfiLoading();
        } else if (state is PerfilFailureState) {
          // Si es "No autenticado", mostrar el prompt de login
          if (state.message == 'No autenticado') {
            return PerfilLoginPrompt(
              onLogin: () {
                final perfilPageState = context
                    .findAncestorStateOfType<_PerfilPageState>();
                if (perfilPageState != null) {
                  perfilPageState._goToLogin();
                }
              },
            );
          }
          return PerfilFailure(state.message);
        } else if (state is PerfilSuccessState) {
          return PerfilSuccess(state.user);
        }
        return const PerfiLoading();
      },
    );
  }
}
