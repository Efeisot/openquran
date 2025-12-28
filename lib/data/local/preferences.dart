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
  static const String _defaultTranslationAuthorIdKey =
      'defaultTranslationAuthorId';
  static const String _customColorKey = 'customColor';
  static const String _systemFontKey = 'systemFont';

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

  int? getDefaultTranslationAuthorId() {
    return _prefs.getInt(_defaultTranslationAuthorIdKey);
  }

  Future<void> setDefaultTranslationAuthorId(int? authorId) async {
    if (authorId == null) {
      await _prefs.remove(_defaultTranslationAuthorIdKey);
    } else {
      await _prefs.setInt(_defaultTranslationAuthorIdKey, authorId);
    }
  }

  // Custom color (nullable - null means use Material You or default)
  Color? getCustomColor() {
    final colorValue = _prefs.getInt(_customColorKey);
    if (colorValue != null) {
      return Color(colorValue);
    }
    return null;
  }

  Future<void> setCustomColor(Color? color) async {
    if (color == null) {
      await _prefs.remove(_customColorKey);
    } else {
      await _prefs.setInt(_customColorKey, color.value);
    }
  }

  // System font (nullable - null means use default)
  String? getSystemFont() {
    return _prefs.getString(_systemFontKey);
  }

  Future<void> setSystemFont(String? font) async {
    if (font == null) {
      await _prefs.remove(_systemFontKey);
    } else {
      await _prefs.setString(_systemFontKey, font);
    }
  }
}

final preferencesProvider = Provider<Preferences>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return Preferences(prefs);
});
