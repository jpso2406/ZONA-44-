import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/features/menu/bloc/menu_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Vista que muestra los grupos de productos con diseño moderno
class GruposView extends StatefulWidget {
  final List<Grupo> grupos;

  const GruposView({required this.grupos, super.key});

  @override
  State<GruposView> createState() => _GruposViewState();
}

class _GruposViewState extends State<GruposView> {
  List<Grupo> get _filteredGrupos => widget.grupos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFF0A2E6E),
        child: Column(
          children: [
            // Título de sección
            _buildHeader(),
            // 🍽️ Grid de grupos
            Expanded(
              child: _filteredGrupos.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: _filteredGrupos.length,
                      itemBuilder: (context, index) {
                        final grupo = _filteredGrupos[index];
                        return GestureDetector(
                          onTap: () {
                            context.read<MenuBloc>().add(
                              SelectGrupo(grupo.slug),
                            );
                          },
                          child: CardGroup(grupo: grupo),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Categorias',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                'La magia comienza con una buena elección',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Color(0xFFEF8307)),
          const SizedBox(height: 16),
          Text(
            'No se encontraron categorías',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otro término de búsqueda',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color.fromARGB(255, 255, 239, 239),
            ),
          ),
        ],
      ),
    );
  }
}
