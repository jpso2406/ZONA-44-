import 'package:flutter/material.dart';
import 'package:zona44app/models/promocion.dart';
import 'dart:async';
import 'promotion_card.dart';
import 'package:zona44app/services/promocion_service.dart';

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
      return Container(
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEF8307)),
          ),
        ),
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
