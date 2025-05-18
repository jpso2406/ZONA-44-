/// Estructura de carpetas:
/// - lib/
///   - main.dart
///   - models/plato.dart
///   - bloc/plato_bloc.dart
///   - bloc/plato_event.dart
///   - bloc/plato_state.dart
///   - repositories/plato_repository.dart
///   - screens/menu_screen.dart

// ==================== lib/main.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/plato_bloc.dart';
import 'repositories/plato_repository.dart';
import 'screens/menu_screen.dart';

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
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_llamas.png',
              fit: BoxFit.cover,
            ),
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
                        Text('Domicilios 🚚', style: TextStyle(color: Colors.orange)),
                        Text('Para llevar 📦', style: TextStyle(color: Colors.orange)),
                        Text('En el local 🏪', style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                    const SizedBox(height: 40),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool esPantallaGrande = constraints.maxWidth > 600;
                        return esPantallaGrande
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BotonRojo(texto: 'como llegar'),
                                  const SizedBox(width: 16),
                                  BotonRojo(
                                    texto: 'Ver Menú',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) => PlatoBloc(PlatoRepository())..add(CargarPlatos()),
                                            child: MenuScreen(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  BotonRojo(texto: 'whatsapp'),
                                ],
                              )
                            : Column(
                                children: [
                                  BotonRojo(texto: 'como llegar'),
                                  const SizedBox(height: 10),
                                  BotonRojo(
                                    texto: 'Ver Menú',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (_) => PlatoBloc(PlatoRepository())..add(CargarPlatos()),
                                            child: MenuScreen(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

// ==================== lib/models/plato.dart ====================
import 'package:equatable/equatable.dart';

class Plato extends Equatable {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;

  const Plato({required this.id, required this.nombre, required this.descripcion, required this.precio});

  factory Plato.fromJson(Map<String, dynamic> json) => Plato(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        precio: (json['precio'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [id, nombre, descripcion, precio];
}

// ==================== lib/bloc/plato_event.dart ====================
import 'package:equatable/equatable.dart';

abstract class PlatoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CargarPlatos extends PlatoEvent {}

// ==================== lib/bloc/plato_state.dart ====================
import 'package:equatable/equatable.dart';
import '../models/plato.dart';

abstract class PlatoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlatoInicial extends PlatoState {}

class PlatoCargando extends PlatoState {}

class PlatoCargado extends PlatoState {
  final List<Plato> platos;

  PlatoCargado(this.platos);

  @override
  List<Object?> get props => [platos];
}

class PlatoError extends PlatoState {
  final String mensaje;

  PlatoError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}

// ==================== lib/bloc/plato_bloc.dart ====================
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/plato_repository.dart';
import 'plato_event.dart';
import 'plato_state.dart';

class PlatoBloc extends Bloc<PlatoEvent, PlatoState> {
  final PlatoRepository repository;

  PlatoBloc(this.repository) : super(PlatoInicial()) {
    on<CargarPlatos>((event, emit) async {
      emit(PlatoCargando());
      try {
        final platos = await repository.obtenerPlatos();
        emit(PlatoCargado(platos));
      } catch (_) {
        emit(PlatoError('No se pudieron cargar los platos.'));
      }
    });
  }
}

// ==================== lib/repositories/plato_repository.dart ====================
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plato.dart';

class PlatoRepository {
  final String url = 'https://run.mocky.io/v3/9c3d5f7f-d36f-4b10-97e1-ffb0df3e2eab';

  Future<List<Plato>> obtenerPlatos() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Plato.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los platos');
    }
  }
}

// ==================== lib/screens/menu_screen.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/plato_bloc.dart';
import '../bloc/plato_state.dart';
import '../models/plato.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú Zona 44')),
      body: BlocBuilder<PlatoBloc, PlatoState>(
        builder: (context, state) {
          if (state is PlatoCargando) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PlatoCargado) {
            return ListView.builder(
              itemCount: state.platos.length,
              itemBuilder: (context, index) {
                final Plato plato = state.platos[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(plato.nombre),
                    subtitle: Text(plato.descripcion),
                    trailing: Text('\$${plato.precio.toStringAsFixed(2)}'),
                  ),
                );
              },
            );
          } else if (state is PlatoError) {
            return Center(child: Text(state.mensaje));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

