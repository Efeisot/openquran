import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../data/local/preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../data/repository/quran_repository.dart';
import '../../data/local/database.dart';

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
  int? _selectedTranslatorId;

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
    ref.read(localeProvider.notifier).setLocale(Locale(code));
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Icon(Icons.menu_book, size: 60, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                'openQuran',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),

              // Language Selection - Compact
              Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _compactLanguageTile('English', 'en', colorScheme),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _compactLanguageTile('Türkçe', 'tr', colorScheme),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Theme Selection - Compact
              Text(
                l10n.theme,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _compactThemeTile(
                      l10n.system,
                      ThemeMode.system,
                      Icons.brightness_auto,
                      colorScheme,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _compactThemeTile(
                      l10n.light,
                      ThemeMode.light,
                      Icons.brightness_5,
                      colorScheme,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _compactThemeTile(
                      l10n.dark,
                      ThemeMode.dark,
                      Icons.brightness_2,
                      colorScheme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Compact toggles
              SwitchListTile(
                title: Text(
                  l10n.materialYou,
                  style: const TextStyle(fontSize: 14),
                ),
                value: _materialYou,
                onChanged: _updateMaterialYou,
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              if (_selectedTheme == ThemeMode.dark)
                SwitchListTile(
                  title: Text(
                    l10n.amoledMode,
                    style: const TextStyle(fontSize: 14),
                  ),
                  value: _amoledMode,
                  onChanged: _updateAmoledMode,
                  activeColor: colorScheme.primary,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              const SizedBox(height: 16),

              // Default Translation Selector
              Text(
                l10n.defaultTranslation,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<List<Author>>(
                future: ref.read(quranRepositoryProvider).getAuthors(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        l10n.none,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }
                  final authors = snapshot.data!;
                  return DropdownButtonFormField<int?>(
                    value: _selectedTranslatorId,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text(l10n.none),
                      ),
                      ...authors.map(
                        (author) => DropdownMenuItem<int?>(
                          value: author.id,
                          child: Text(
                            author.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedTranslatorId = value);
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Compact Get Started Button
              FilledButton(
                onPressed: _selectedLanguage != null
                    ? () => _completeOnboarding()
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  l10n.language == 'tr' ? 'Başlayın' : 'Get Started',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _compactLanguageTile(
    String label,
    String code,
    ColorScheme colorScheme,
  ) {
    final isSelected = _selectedLanguage == code;
    return InkWell(
      onTap: () => _updateLanguage(code),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _compactThemeTile(
    String label,
    ThemeMode mode,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    final isSelected = _selectedTheme == mode;
    return InkWell(
      onTap: () => _updateTheme(mode),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurface,
              ),
            ),
          ],
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
    await prefs.setDefaultTranslationAuthorId(_selectedTranslatorId);
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
