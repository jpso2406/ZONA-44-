import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'package:zona44app/models/table_reservation.dart';
import 'package:zona44app/services/reservation_service.dart';
import 'package:intl/intl.dart';
import 'custom_text_field.dart';

class ReservationForm extends StatefulWidget {
  final String? token;
  final VoidCallback? onReservationCreated;

  const ReservationForm({super.key, this.token, this.onReservationCreated});

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
  final ReservationService _reservationService = ReservationService();
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  // Form data
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _peopleCount = 2;

  // State
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEF8307),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0A2E6E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFEF8307),
              onPrimary: Colors.white,
              onSurface: Color(0xFF0A2E6E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitReservation() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectDate),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectTime),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final reservation = TableReservation(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        date: _selectedDate!,
        time: _selectedTime!.format(context),
        peopleCount: _peopleCount,
        comments: _commentsController.text,
      );

      final result = await _reservationService.createReservation(reservation);

      if (result['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.reservationSuccess),
              backgroundColor: Colors.green,
            ),
          );

          // Limpiar formulario
          _formKey.currentState!.reset();
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _commentsController.clear();
          setState(() {
            _selectedDate = null;
            _selectedTime = null;
            _peopleCount = 2;
          });

          // Notificar creación de reserva
          widget.onReservationCreated?.call();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['errors']?.join(', ') ??
                    AppLocalizations.of(context)!.reservationError,
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.reservationError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nombre
            CustomTextField(
              controller: _nameController,
              label: AppLocalizations.of(context)!.name,
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterName;
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email
            CustomTextField(
              controller: _emailController,
              label: AppLocalizations.of(context)!.email,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterEmail;
                }
                if (!value.contains('@')) {
                  return 'Email inválido';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Teléfono
            CustomTextField(
              controller: _phoneController,
              label: AppLocalizations.of(context)!.phone,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterPhone;
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Fecha
            _buildDateSelector(),

            const SizedBox(height: 16),

            // Hora
            _buildTimeSelector(),

            const SizedBox(height: 16),

            // Número de personas
            _buildPeopleCounter(),

            const SizedBox(height: 16),

            // Comentarios
            CustomTextField(
              controller: _commentsController,
              label: AppLocalizations.of(context)!.commentsOptional,
              icon: Icons.comment,
              maxLines: 3,
              required: false,
            ),

            const SizedBox(height: 24),

            // Botón enviar
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReservation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF8307),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.submitReservation,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFFEF8307)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDate == null
                    ? AppLocalizations.of(context)!.selectDate
                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                style: GoogleFonts.poppins(
                  color: _selectedDate == null
                      ? Colors.grey
                      : const Color(0xFF0A2E6E),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _selectTime,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, color: Color(0xFFEF8307)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedTime == null
                    ? AppLocalizations.of(context)!.selectTime
                    : _selectedTime!.format(context),
                style: GoogleFonts.poppins(
                  color: _selectedTime == null
                      ? Colors.grey
                      : const Color(0xFF0A2E6E),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeopleCounter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.group, color: Color(0xFFEF8307)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.numberOfPeople,
              style: GoogleFonts.poppins(
                color: const Color(0xFF0A2E6E),
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: const Color(0xFFEF8307),
            onPressed: () {
              if (_peopleCount > 1) {
                setState(() => _peopleCount--);
              }
            },
          ),
          Text(
            '$_peopleCount',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0A2E6E),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: const Color(0xFFEF8307),
            onPressed: () {
              if (_peopleCount < 20) {
                setState(() => _peopleCount++);
              }
            },
          ),
        ],
      ),
    );
  }
}
