import 'package:flutter/material.dart';
import 'package:zona44app/main.dart';
import 'package:zona44app/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  String _getFlagEmoji(String languageCode) {
    switch (languageCode) {
      case 'es':
        return '🇪🇸';
      case 'en':
        return '🇺🇸';
      default:
        return '🌐';
    }
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'es':
        return 'Español';
      case 'en':
        return 'English';
      default:
        return 'Language';
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = LocaleProvider.of(context).locale;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.language, color: Color(0xFF0A2E6E)),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.language,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              'es',
              '🇪🇸',
              'Español',
              currentLocale.languageCode == 'es',
            ),
            const SizedBox(height: 10),
            _buildLanguageOption(
              context,
              'en',
              '🇺🇸',
              'English',
              currentLocale.languageCode == 'en',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: const TextStyle(color: Color(0xFF0A2E6E)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageCode,
    String flag,
    String languageName,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        LocaleProvider.of(context).changeLocale(Locale(languageCode));
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A2E6E).withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: const Color(0xFF0A2E6E), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 15),
            Text(
              languageName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF0A2E6E) : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF0A2E6E),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = LocaleProvider.of(context).locale;

    return ElevatedButton.icon(
      onPressed: () => _showLanguageDialog(context),
      icon: Text(
        _getFlagEmoji(currentLocale.languageCode),
        style: const TextStyle(fontSize: 18),
      ),
      label: Text(
        _getLanguageName(currentLocale.languageCode),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFEF8307),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(0, 36),
      ),
    );
  }
}
