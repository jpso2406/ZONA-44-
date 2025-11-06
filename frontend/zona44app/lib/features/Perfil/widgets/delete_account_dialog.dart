import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zona44app/services/user_service.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class DeleteAccountDialog extends StatefulWidget {
  final String token;

  const DeleteAccountDialog({required this.token, super.key});

  Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _isConfirmed = false;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  void _checkConfirmation() {
    setState(() {
      final locale = Localizations.localeOf(context).languageCode;
      final confirmWord = locale == 'es' ? 'eliminar' : 'delete';
      _isConfirmed = _confirmController.text.toLowerCase() == confirmWord;
    });
  }

  Future<void> _deleteAccount() async {
    if (!_isConfirmed) return;

    setState(() => _isLoading = true);

    try {
      final response = await UserService().deleteAccount(widget.token);

      if (response['success'] == true) {
        Navigator.of(context).pop(true); // Indica que se eliminó exitosamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ??
                  AppLocalizations.of(context)!.accountDeletedSuccessfully,
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ??
                  AppLocalizations.of(context)!.errorDeletingAccount,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        size: 60,
                        color: Colors.red.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.deleteAccount,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.deleteAccountWarning,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.deleteConfirmInstruction,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmController,
                            onChanged: (_) => _checkConfirmation(),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(
                                context,
                              )!.typeDeleteHere,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.red.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.red.shade500,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _isLoading
                                ? null
                                : () => Navigator.of(context).pop(false),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (_isLoading || !_isConfirmed)
                                ? null
                                : _deleteAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.deleteAccount,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                    onPressed: () => Navigator.pop(context, false),
                    tooltip: AppLocalizations.of(context)!.close,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms);
  }
}
