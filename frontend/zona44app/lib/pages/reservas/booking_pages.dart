import 'package:flutter/material.dart';
import 'widgets/boton_confirmar.dart';
import 'widgets/campo_fecha_hora.dart';
import 'widgets/campo_nombre.dart';
import 'widgets/campo_personas.dart';
import 'widgets/campo_telefono.dart';


class ReservaPages extends StatefulWidget {
  @override
  _UserBookingScreenState createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<ReservaPages>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String nombre = "";
  String telefono = "";
  int personas = 1;
  DateTime? fechaHoraSeleccionada;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _mostrarAlertaReserva() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("¡Reserva confirmada!"),
            ],
          ),
          content: Text(
            "Tu reserva se realizó con éxito para el día "
            "${fechaHoraSeleccionada!.day}/${fechaHoraSeleccionada!.month}/${fechaHoraSeleccionada!.year} "
            "a las ${fechaHoraSeleccionada!.hour}:${fechaHoraSeleccionada!.minute.toString().padLeft(2, '0')}.",
          ),
          actions: [
            TextButton(
              child: Text("Aceptar", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pop(context); // Vuelve a la pantalla anterior
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF040E3F), Color(0xFF0A2E6E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.all(30),
                    icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 239, 240, 244)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Reservar Mesa",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF040E3F),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  CampoNombre(onSaved: (value) => nombre = value),
                                  SizedBox(height: 15),
                                  CampoTelefono(onSaved: (value) => telefono = value),
                                  SizedBox(height: 15),
                                  CampoPersonas(onSaved: (value) => personas = value),
                                  SizedBox(height: 15),
                                  CampoFechaHora(
                                    fechaSeleccionada: fechaHoraSeleccionada,
                                    onFechaSeleccionada: (fecha) {
                                      setState(() => fechaHoraSeleccionada = fecha);
                                    },
                                  ),
                                  SizedBox(height: 25),
                                  BotonConfirmar(
                                    formKey: _formKey,
                                    fechaHoraSeleccionada: fechaHoraSeleccionada,
                                    onConfirmar: _mostrarAlertaReserva,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
