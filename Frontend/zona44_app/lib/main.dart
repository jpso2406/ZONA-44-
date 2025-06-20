import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/plato_bloc.dart';
import 'bloc/plato_event.dart';
import 'bloc/categoria_bloc.dart';
import 'bloc/categoria_event.dart';
import 'bloc/carrito_bloc.dart';

import 'repositories/plato_repository.dart';
import 'repositories/categoria_repository.dart';

import 'screens/categorias_screen.dart';
import 'screens/platos_screen.dart';
import 'screens/carrito_screen.dart';
import 'screens/resumen_compra_screen.dart';

void main() {
  runApp(const Zona44App());
}

class Zona44App extends StatelessWidget {
  const Zona44App({super.key});

  @override
  Widget build(BuildContext context) {
    final platoRepository = PlatoRepository();
    final categoriaRepository = CategoriaRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PlatoBloc(platoRepository)..add(CargarPlatos())),
        BlocProvider(create: (_) => CategoriaBloc(categoriaRepository)..add(CargarCategorias())),
        BlocProvider(create: (_) => CarritoBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        routes: {
          '/bienvenidos': (context) => const BienvenidosScreen(),
          '/categorias': (context) => CategoriasScreen(),
          '/platos': (context) {
            final args = ModalRoute.of(context)?.settings.arguments;
            final categoria = (args is String) ? args : '';
            return PlatosScreen(categoria: categoria);
          },
          '/carrito': (context) => const CarritoScreen(),
          '/resumen': (context) => const ResumenCompraScreen(),
        },
      ),
    );
  }
}

/// SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BienvenidosScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Image.asset('assets/images/zona44_logo.png', width: 200, height: 200),
        ),
      ),
    );
  }
}

/// PANTALLA PRINCIPAL
class BienvenidosScreen extends StatelessWidget {
  const BienvenidosScreen({super.key});

  Future<void> abrirGoogleMaps() async {
    final destino = Uri.encodeComponent('Cra. 80 #45-32, Medellín');
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$destino');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ No se pudo abrir el navegador con Google Maps.");
    }
  }

  Future<void> abrirWhatsApp() async {
    final numero = '573001112233';
    final mensaje = Uri.encodeComponent("¡Hola! Estoy interesado en los productos de Zona 44.");
    final Uri url = Uri.parse("https://wa.me/$numero?text=$mensaje");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("❌ No se pudo abrir WhatsApp.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/fondo_llamas.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('assets/images/zona44_logo.png', height: 270),
                    const SizedBox(height: 10),
                    const Text(
                      'Bienvenidos',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Zona 44 es un lugar en el cual vas a disfrutar y pasar ratos agradables',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Domicilios 🚚', style: TextStyle(color: Colors.orange)),
                        Text('Para llevar 📦', style: TextStyle(color: Colors.orange)),
                        Text('En el local 🏪', style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                    const SizedBox(height: 40),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool esPantallaGrande = constraints.maxWidth > 600;
                        final botones = [
                          BotonRojo(texto: 'Cómo llegar', onPressed: abrirGoogleMaps),
                          const SizedBox(width: 16, height: 10),
                          BotonRojo(
                            texto: 'Ver Menú',
                            onPressed: () => Navigator.pushNamed(context, '/categorias'),
                          ),
                          const SizedBox(width: 16, height: 10),
                          BotonRojo(texto: 'WhatsApp', onPressed: abrirWhatsApp),
                        ];
                        return esPantallaGrande
                            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: botones)
                            : Column(children: botones);
                      },
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey.shade900,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Menú digital', style: TextStyle(color: Colors.redAccent)),
                  Text('reportar algo', style: TextStyle(color: Colors.redAccent)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// BOTÓN ESTILIZADO
class BotonRojo extends StatelessWidget {
  final String texto;
  final VoidCallback? onPressed;
  const BotonRojo({super.key, required this.texto, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
