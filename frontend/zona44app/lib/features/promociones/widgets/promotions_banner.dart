import 'package:flutter/material.dart';
import 'package:zona44app/models/promocion.dart';
import 'dart:async';
import 'promotion_card.dart';
import 'package:zona44app/services/promocion_service.dart';
import 'package:shimmer/shimmer.dart';

class PromotionsBanner extends StatefulWidget {
  const PromotionsBanner({super.key});

  @override
  State<PromotionsBanner> createState() => _PromotionsBannerState();
}

class _PromotionsBannerState extends State<PromotionsBanner> {
  final PromocionService _promocionService = PromocionService();
  final PageController _pageController = PageController();
  List<Promocion> _promociones = [];
  bool _isLoading = true;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadPromociones();
  }

  Future<void> _loadPromociones() async {
    try {
      final promociones = await _promocionService.getPromocionesPublicas();
      if (mounted) {
        setState(() {
          _promociones = promociones;
          _isLoading = false;
        });

        // Iniciar auto-scroll solo si hay promociones
        if (_promociones.isNotEmpty) {
          _startAutoScroll();
        }
      }
    } catch (e) {
      print('Error loading promociones: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && _promociones.isNotEmpty) {
        final nextPage = (_currentPage + 1) % _promociones.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Column(
        children: [
          Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFEF8307).withOpacity(0.3),
              highlightColor: const Color(0xFFFF9F3D).withOpacity(0.6),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF8307), Color(0xFFFF9F3D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Simulación de contenido
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Badge de descuento simulado
                          Container(
                            width: 80,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Título simulado
                          Container(
                            width: 180,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 140,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Precios simulados
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 80,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Indicadores de página simulados
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF8307).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (_promociones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Carrusel
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _promociones.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PromotionCard(promocion: _promociones[index]),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // Indicadores de página
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promociones.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? const Color(0xFFEF8307)
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
