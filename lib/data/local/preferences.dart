import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class Preferences {
  final SharedPreferences _prefs;

  Preferences(this._prefs);

  static const String _themeModeKey = 'themeMode';
  static const String _amoledModeKey = 'amoledMode';
  static const String _languageKey = 'language';
  static const String _lastReadSurahKey = 'lastReadSurah';
  static const String _lastReadVerseKey = 'lastReadVerse';
  static const String _materialYouKey = 'materialYou';
  static const String _onboardingCompletedKey = 'onboardingCompleted';

  ThemeMode getThemeMode() {
    final index = _prefs.getInt(_themeModeKey);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_themeModeKey, mode.index);
  }

  bool getAmoledMode() {
    return _prefs.getBool(_amoledModeKey) ?? false;
  }

  Future<void> setAmoledMode(bool enabled) async {
    await _prefs.setBool(_amoledModeKey, enabled);
  }

  Locale? getLocale() {
    final code = _prefs.getString(_languageKey);
    if (code != null) {
      return Locale(code);
    }
    return null;
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(_languageKey, locale.languageCode);
  }

  Future<void> setLastRead(int surahId, int verseNumber) async {
    await Future.wait([
      _prefs.setInt(_lastReadSurahKey, surahId),
      _prefs.setInt(_lastReadVerseKey, verseNumber),
    ]);
  }

  bool getOnboardingCompleted() {
    return _prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  Future<void> setOnboardingCompleted(bool value) {
    return _prefs.setBool(_onboardingCompletedKey, value);
  }

  (int, int)? getLastRead() {
    final surah = _prefs.getInt(_lastReadSurahKey);
    final verse = _prefs.getInt(_lastReadVerseKey);
    if (surah != null && verse != null) {
      return (surah, verse);
    }
    return null;
  }

  bool getMaterialYou() {
    return _prefs.getBool(_materialYouKey) ??
        true; // Default to true for Material You
  }

  Future<void> setMaterialYou(bool enabled) async {
    await _prefs.setBool(_materialYouKey, enabled);
  }
}

final preferencesProvider = Provider<Preferences>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return Preferences(prefs);
});
