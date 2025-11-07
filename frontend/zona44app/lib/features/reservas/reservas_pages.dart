import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/reservations_header.dart';
import 'widgets/reservations_tabs.dart';
import 'widgets/reservation_form.dart';
import 'widgets/reservations_list.dart';

class ReservasPages extends StatefulWidget {
  const ReservasPages({super.key});

  @override
  State<ReservasPages> createState() => _ReservasPagesState();
}

class _ReservasPagesState extends State<ReservasPages> {
  bool _showMyReservations = false;
  String? _token;
  final GlobalKey<State> _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadUserToken();
  }

  Future<void> _loadUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('api_token');
    });
  }

  void _onReservationCreated() {
    // Recargar la lista de reservas si está autenticado
    if (_token != null && _listKey.currentState != null) {
      (_listKey.currentState as dynamic)._loadReservations?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A2E6E), Color(0xFF1A4A8A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              const ReservationsHeader(),

              // Tabs (si está autenticado)
              if (_token != null && _token!.isNotEmpty) ...[
                ReservationsTabs(
                  showMyReservations: _showMyReservations,
                  onTabChanged: (value) {
                    setState(() {
                      _showMyReservations = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],

              // Content
              Expanded(
                child: _showMyReservations && _token != null
                    ? ReservationsList(key: _listKey, token: _token!)
                    : ReservationForm(
                        token: _token,
                        onReservationCreated: _onReservationCreated,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
