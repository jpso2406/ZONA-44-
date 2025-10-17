import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/menu/bloc/menu_bloc.dart';
import 'package:zona44app/l10n/app_localizations.dart';

// Vista que muestra los grupos de productos en una cuadrícula
class GruposView extends StatelessWidget {
  final List<Grupo> grupos;

  const GruposView({required this.grupos, super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.categories,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: grupos.length,
              itemBuilder: (context, index) {
                final grupo = grupos[index];
                return GestureDetector(
                  onTap: () {
                    context.read<MenuBloc>().add(SelectGrupo(grupo.slug));
                  },
                  child: CardGroup(grupo: grupo),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
