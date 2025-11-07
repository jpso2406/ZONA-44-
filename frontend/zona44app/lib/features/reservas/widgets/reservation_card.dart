import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'package:zona44app/models/table_reservation.dart';
import 'package:intl/intl.dart';

class ReservationCard extends StatelessWidget {
  final TableReservation reservation;
  final VoidCallback onCancel;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con nombre y estado
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  reservation.name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0A2E6E),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusInfo['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusInfo['color']),
                ),
                child: Text(
                  statusInfo['text'],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusInfo['color'],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Fecha
          _buildDetail(
            Icons.calendar_today,
            DateFormat('dd/MM/yyyy').format(reservation.date),
          ),

          const SizedBox(height: 8),

          // Hora
          _buildDetail(Icons.access_time, reservation.time),

          const SizedBox(height: 8),

          // Personas
          _buildDetail(
            Icons.group,
            '${reservation.peopleCount} ${AppLocalizations.of(context)!.peopleCount}',
          ),

          // Comentarios (si existen)
          if (reservation.comments.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildDetail(Icons.comment, reservation.comments),
          ],

          // Botón cancelar (solo para pendientes)
          if (reservation.status.toLowerCase() == 'pendiente') ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.cancelReservation,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFEF8307)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getStatusInfo(BuildContext context) {
    switch (reservation.status.toLowerCase()) {
      case 'confirmada':
        return {
          'color': Colors.green,
          'text': AppLocalizations.of(context)!.reservationStatusConfirmed,
        };
      case 'cancelada':
        return {
          'color': Colors.red,
          'text': AppLocalizations.of(context)!.reservationStatusCancelled,
        };
      default:
        return {
          'color': Colors.orange,
          'text': AppLocalizations.of(context)!.reservationStatusPending,
        };
    }
  }
}
