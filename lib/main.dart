import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';
import 'ui/home/home_screen.dart';
import 'ui/onboarding/onboarding_screen.dart';
import 'ui/theme/app_theme.dart';
import 'data/local/preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final prefs = ref.watch(preferencesProvider);
  return ThemeModeNotifier(prefs);
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Preferences _prefs;
  ThemeModeNotifier(this._prefs) : super(_prefs.getThemeMode());

  void setMode(ThemeMode mode) {
    state = mode;
    _prefs.setThemeMode(mode);
  }
}

final amoledModeProvider = StateNotifierProvider<AmoledModeNotifier, bool>((
  ref,
) {
  final prefs = ref.watch(preferencesProvider);
  return AmoledModeNotifier(prefs);
});

class AmoledModeNotifier extends StateNotifier<bool> {
  final Preferences _prefs;
  AmoledModeNotifier(this._prefs) : super(_prefs.getAmoledMode());

  void setMode(bool mode) {
    state = mode;
    _prefs.setAmoledMode(mode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final prefs = ref.watch(preferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale?> {
  final Preferences _prefs;
  LocaleNotifier(this._prefs) : super(_prefs.getLocale());

  void setLocale(Locale locale) {
    state = locale;
    _prefs.setLocale(locale);
  }
}

final materialYouProvider = StateNotifierProvider<MaterialYouNotifier, bool>((
  ref,
) {
  final prefs = ref.watch(preferencesProvider);
  return MaterialYouNotifier(prefs);
});

class MaterialYouNotifier extends StateNotifier<bool> {
  final Preferences _prefs;
  MaterialYouNotifier(this._prefs) : super(_prefs.getMaterialYou());

  void setEnabled(bool enabled) {
    state = enabled;
    _prefs.setMaterialYou(enabled);
  }
}

final customColorProvider = StateNotifierProvider<CustomColorNotifier, Color?>((
  ref,
) {
  final prefs = ref.watch(preferencesProvider);
  return CustomColorNotifier(prefs);
});

class CustomColorNotifier extends StateNotifier<Color?> {
  final Preferences _prefs;
  CustomColorNotifier(this._prefs) : super(_prefs.getCustomColor());

  void setColor(Color? color) {
    state = color;
    _prefs.setCustomColor(color);
  }
}

final systemFontProvider = StateNotifierProvider<SystemFontNotifier, String?>((
  ref,
) {
  final prefs = ref.watch(preferencesProvider);
  return SystemFontNotifier(prefs);
});

class SystemFontNotifier extends StateNotifier<String?> {
  final Preferences _prefs;
  SystemFontNotifier(this._prefs) : super(_prefs.getSystemFont());

  void setFont(String? font) {
    state = font;
    _prefs.setSystemFont(font);
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isAmoled = ref.watch(amoledModeProvider);
    final locale = ref.watch(localeProvider);
    final useMaterialYou = ref.watch(materialYouProvider);
    final customColor = ref.watch(customColorProvider);
    final systemFont = ref.watch(systemFontProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme? lightColorScheme;
        ColorScheme? darkColorScheme;

        if (useMaterialYou && lightDynamic != null && darkDynamic != null) {
          // Use Material You colors
          lightColorScheme = lightDynamic;
          darkColorScheme = darkDynamic;
        } else if (customColor != null) {
          // Use custom color
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: customColor,
            brightness: Brightness.light,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: customColor,
            brightness: Brightness.dark,
          );
        } else {
          // Use default theme colors
          lightColorScheme = null;
          darkColorScheme = null;
        }

        // Get base text theme with selected font
        TextTheme getTextTheme(TextTheme baseTextTheme) {
          if (systemFont != null && systemFont.isNotEmpty) {
            return GoogleFonts.getTextTheme(systemFont, baseTextTheme);
          }
          return GoogleFonts.interTextTheme(baseTextTheme);
        }

        return MaterialApp(
          title: 'Açık Kuran',
          debugShowCheckedModeBanner: false,
          theme: lightColorScheme != null
              ? ThemeData(
                  useMaterial3: true,
                  colorScheme: lightColorScheme,
                  textTheme: getTextTheme(ThemeData.light().textTheme),
                )
              : AppTheme.lightTheme.copyWith(
                  textTheme: getTextTheme(AppTheme.lightTheme.textTheme),
                ),
          darkTheme: () {
            // If AMOLED mode is enabled, use pure black theme
            if (isAmoled) {
              if (darkColorScheme != null) {
                // Apply AMOLED colors to custom/Material You theme
                return ThemeData(
                  useMaterial3: true,
                  colorScheme: darkColorScheme.copyWith(
                    surface: Colors.black,
                    background: Colors.black,
                  ),
                  scaffoldBackgroundColor: Colors.black,
                  textTheme: getTextTheme(ThemeData.dark().textTheme),
                  appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.black,
                    surfaceTintColor: Colors.transparent,
                  ),
                );
              } else {
                // Use custom AMOLED theme
                return AppTheme.amoledTheme.copyWith(
                  textTheme: getTextTheme(AppTheme.amoledTheme.textTheme),
                );
              }
            } else {
              // AMOLED mode is OFF - use regular dark theme
              if (darkColorScheme != null) {
                // Use custom/Material You dark theme
                return ThemeData(
                  useMaterial3: true,
                  colorScheme: darkColorScheme,
                  textTheme: getTextTheme(ThemeData.dark().textTheme),
                );
              } else {
                // Use default dark theme
                return AppTheme.darkTheme.copyWith(
                  textTheme: getTextTheme(AppTheme.darkTheme.textTheme),
                );
              }
            }
          }(),
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ref.watch(preferencesProvider).getOnboardingCompleted()
              ? const HomeScreen()
              : const OnboardingScreen(),
        );
      },
    );
  }
}
