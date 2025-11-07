import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'package:zona44app/models/table_reservation.dart';
import 'package:zona44app/services/reservation_service.dart';
import 'reservation_card.dart';

class ReservationsList extends StatefulWidget {
  final String token;

  const ReservationsList({super.key, required this.token});

  @override
  State<ReservationsList> createState() => _ReservationsListState();
}

class _ReservationsListState extends State<ReservationsList> {
  final ReservationService _reservationService = ReservationService();
  List<TableReservation> _reservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final reservations = await _reservationService.getUserReservations(
        widget.token,
      );
      if (mounted) {
        setState(() {
          _reservations = reservations;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading reservations: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _cancelReservation(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          AppLocalizations.of(context)!.cancelReservation,
          style: GoogleFonts.poppins(
            color: const Color(0xFF0A2E6E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.confirmCancelReservation,
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _reservationService.cancelReservation(
          widget.token,
          id,
        );
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.reservationCancelled),
              backgroundColor: Colors.green,
            ),
          );
          _loadReservations();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.errorCancellingReservation,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEF8307)),
        ),
      );
    }

    if (_reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: Color(0xFFEF8307),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noReservations,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _reservations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final reservation = _reservations[index];
        return ReservationCard(
          reservation: reservation,
          onCancel: () => _cancelReservation(reservation.id!),
        );
      },
    );
  }
}
