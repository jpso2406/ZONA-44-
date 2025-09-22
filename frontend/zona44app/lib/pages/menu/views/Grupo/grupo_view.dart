import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/grupo.dart';
import '../../../../widgets/card_group.dart';
import '../../bloc/menu_bloc.dart';


class GruposView extends StatelessWidget {
  final List<Grupo> grupos;

  const GruposView({required this.grupos, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Categorías',
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
    );
  }
}