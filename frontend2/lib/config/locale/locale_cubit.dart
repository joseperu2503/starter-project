import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _key = 'locale';
  static const _supported = ['en', 'es'];

  LocaleCubit() : super(const Locale('en'));

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);

    if (saved != null && _supported.contains(saved)) {
      emit(Locale(saved));
      return;
    }

    // Auto-detect from device
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    final resolved = _supported.contains(deviceCode) ? deviceCode : 'en';
    await prefs.setString(_key, resolved);
    emit(Locale(resolved));
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
    emit(locale);
  }
}
