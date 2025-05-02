import 'package:flutter/material.dart';

void main() {
  runApp(const Zona44App());
}

class Zona44App extends StatelessWidget {
  const Zona44App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BienvenidosScreen(),
    );
  }
}

class BienvenidosScreen extends StatelessWidget {
  const BienvenidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_llamas.png',
              fit: BoxFit.cover,
            ),
          ),

          // Oscurecer un poco el fondo
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // Contenido principal
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset('assets/images/zona44_logo.png', height: 100),
                    const SizedBox(height: 20),
                    const Text(
                      'Bienvenid@s',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
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
                        Text(
                          'domicilios',
                          style: TextStyle(color: Colors.orange),
                        ),
                        Text(
                          'para llevar',
                          style: TextStyle(color: Colors.orange),
                        ),
                        Text(
                          'en el local',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Layout adaptable para los botones
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool esPantallaGrande = constraints.maxWidth > 600;
                        return esPantallaGrande
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BotonRojo(texto: 'como llegar'),
                                const SizedBox(width: 16),
                                BotonRojo(texto: 'Ver Menú'),
                                const SizedBox(width: 16),
                                BotonRojo(texto: 'whatsapp'),
                              ],
                            )
                            : Column(
                              children: [
                                BotonRojo(texto: 'como llegar'),
                                const SizedBox(height: 10),
                                BotonRojo(texto: 'Ver Menú'),
                                const SizedBox(height: 10),
                                BotonRojo(texto: 'whatsapp'),
                              ],
                            );
                      },
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),

          // Barra inferior
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
                  Text(
                    'Menú digital',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  Text(
                    'reportar algo',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BotonRojo extends StatelessWidget {
  final String texto;
  const BotonRojo({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
