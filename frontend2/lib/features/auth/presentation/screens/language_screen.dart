import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/locale/locale_cubit.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/injection_container.dart';
import 'package:newsly/l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    (code: 'en', name: 'English', native: 'English', flag: '🇺🇸'),
    (code: 'es', name: 'Spanish', native: 'Español', flag: '🇪🇸'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.language)),
      body: BlocBuilder<LocaleCubit, Locale>(
        bloc: sl<LocaleCubit>(),
        builder: (context, currentLocale) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  l10n.selectLanguage,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              ..._languages.map((lang) {
                final isSelected = currentLocale.languageCode == lang.code;
                return Container(
                  color: cs.surface,
                  child: ListTile(
                    leading: Text(lang.flag, style: const TextStyle(fontSize: 28)),
                    title: Text(
                      lang.native,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppTheme.accent : cs.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      lang.name,
                      style: TextStyle(color: cs.onSurface.withValues(alpha: 0.5)),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppTheme.accent)
                        : Icon(Icons.circle_outlined,
                            color: cs.onSurface.withValues(alpha: 0.3)),
                    onTap: () => sl<LocaleCubit>().setLocale(Locale(lang.code)),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
