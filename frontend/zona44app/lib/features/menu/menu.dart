import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/menu/bloc/menu_bloc.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Página del menú que muestra grupos de productos y productos individuales
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuBloc()..add(LoadMenu()),
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          return Container(
            height: 670,
            decoration: BoxDecoration(
              color: Color.fromARGB(240, 4, 14, 63),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MenuState state) {
    if (state is MenuLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.loading,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
    } else if (state is GruposLoaded) {
      return GruposView(grupos: state.grupos);
    } else if (state is ProductosLoaded) {
      return ProductosView(grupo: state.grupo, productos: state.productos);
    } else if (state is MenuError) {
      return _buildErrorView(context, state.message);
    }
    return Container();
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 70,
            color: Color.fromARGB(255, 239, 131, 7),
          ).animate().shake(duration: 600.ms).fadeIn(duration: 400.ms),
          const SizedBox(height: 18),
          Text(
            AppLocalizations.of(context)!.menuError,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(color: Colors.white70, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: () {
              context.read<MenuBloc>().add(LoadMenu());
            },
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(
              AppLocalizations.of(context)!.retry,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 239, 131, 7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ],
      ),
    );
  }
}
