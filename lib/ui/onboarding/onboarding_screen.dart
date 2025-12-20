import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../data/local/preferences.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _selectedLanguage;
  ThemeMode _selectedTheme = ThemeMode.system;
  bool _materialYou = false;
  bool _amoledMode = false;

  @override
  void initState() {
    super.initState();
    // Set initial language to show proper translations
    _selectedLanguage = 'en';
  }

  void _updateLanguage(String code) {
    setState(() {
      _selectedLanguage = code;
    });
    // Apply language change immediately
    ref.read(localeProvider.notifier).state = Locale(code);
  }

  void _updateTheme(ThemeMode mode) {
    setState(() {
      _selectedTheme = mode;
    });
    // Apply theme change immediately
    ref.read(themeModeProvider.notifier).setMode(mode);
  }

  void _updateMaterialYou(bool value) {
    setState(() {
      _materialYou = value;
    });
    ref.read(materialYouProvider.notifier).setEnabled(value);
  }

  void _updateAmoledMode(bool value) {
    setState(() {
      _amoledMode = value;
    });
    ref.read(amoledModeProvider.notifier).setMode(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.menu_book, size: 80, color: colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Açık Kuran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.language == 'tr'
                    ? 'Açık Kuran\'a Hoş Geldiniz'
                    : 'Welcome to Open Quran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                l10n.language == 'tr' ? 'Dil Seçin' : 'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildLanguageTile('English', 'en', colorScheme),
              const SizedBox(height: 8),
              _buildLanguageTile('Türkçe', 'tr', colorScheme),
              const SizedBox(height: 32),
              Text(
                l10n.theme,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildThemeTile(
                l10n.system,
                ThemeMode.system,
                Icons.brightness_auto,
                colorScheme,
              ),
              const SizedBox(height: 8),
              _buildThemeTile(
                l10n.light,
                ThemeMode.light,
                Icons.brightness_5,
                colorScheme,
              ),
              const SizedBox(height: 8),
              _buildThemeTile(
                l10n.dark,
                ThemeMode.dark,
                Icons.brightness_2,
                colorScheme,
              ),
              const SizedBox(height: 24),
              // Material You toggle
              SwitchListTile(
                title: Text(
                  l10n.materialYou,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                value: _materialYou,
                onChanged: _updateMaterialYou,
                activeColor: colorScheme.primary,
              ),
              // AMOLED toggle (only show if dark theme)
              if (_selectedTheme == ThemeMode.dark)
                SwitchListTile(
                  title: Text(
                    l10n.amoledMode,
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  value: _amoledMode,
                  onChanged: _updateAmoledMode,
                  activeColor: colorScheme.primary,
                ),
              const Spacer(),
              FilledButton(
                onPressed: _selectedLanguage != null
                    ? () => _completeOnboarding()
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  l10n.language == 'tr' ? 'Başlayın' : 'Get Started',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(
    String label,
    String code,
    ColorScheme colorScheme,
  ) {
    final isSelected = _selectedLanguage == code;
    return Card(
      elevation: isSelected ? 8 : 1,
      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      child: InkWell(
        onTap: () => _updateLanguage(code),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: colorScheme.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeTile(
    String label,
    ThemeMode mode,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    final isSelected = _selectedTheme == mode;
    return Card(
      elevation: isSelected ? 8 : 1,
      color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
      child: InkWell(
        onTap: () => _updateTheme(mode),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.6),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: colorScheme.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = ref.read(preferencesProvider);

    // Save all settings
    if (_selectedLanguage != null) {
      await prefs.setLocale(Locale(_selectedLanguage!));
    }
    await prefs.setThemeMode(_selectedTheme);
    await prefs.setMaterialYou(_materialYou);
    await prefs.setAmoledMode(_amoledMode);
    await prefs.setOnboardingCompleted(true);

    if (mounted) {
      // Restart the app to apply all settings
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MyApp()),
        (route) => false,
      );
    }
  }
}
