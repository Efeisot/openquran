import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../data/local/preferences.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String? _selectedLanguage;
  ThemeMode? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.menu_book, size: 80, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                'Açık Kuran',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome to Open Quran',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              const Text(
                'Select Language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildLanguageTile('English', 'en'),
              const SizedBox(height: 8),
              _buildLanguageTile('Türkçe', 'tr'),
              const SizedBox(height: 32),
              const Text(
                'Select Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildThemeTile(
                'System',
                ThemeMode.system,
                Icons.brightness_auto,
              ),
              const SizedBox(height: 8),
              _buildThemeTile('Light', ThemeMode.light, Icons.brightness_5),
              const SizedBox(height: 8),
              _buildThemeTile('Dark', ThemeMode.dark, Icons.brightness_2),
              const Spacer(),
              FilledButton(
                onPressed: _selectedLanguage != null && _selectedTheme != null
                    ? () => _completeOnboarding()
                    : null,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(String label, String code) {
    final isSelected = _selectedLanguage == code;
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.teal.shade50 : null,
      child: ListTile(
        title: Text(label),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.teal)
            : null,
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
        },
      ),
    );
  }

  Widget _buildThemeTile(String label, ThemeMode mode, IconData icon) {
    final isSelected = _selectedTheme == mode;
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.teal.shade50 : null,
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.teal : null),
        title: Text(label),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.teal)
            : null,
        onTap: () {
          setState(() {
            _selectedTheme = mode;
          });
        },
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = ref.read(preferencesProvider);

    // Save language
    if (_selectedLanguage != null) {
      await prefs.setLocale(Locale(_selectedLanguage!));
      // Update the locale provider properly
      await Future.delayed(Duration.zero);
    }

    // Save theme
    if (_selectedTheme != null) {
      await prefs.setThemeMode(_selectedTheme!);
    }

    // Mark onboarding as complete
    await prefs.setOnboardingCompleted(true);

    if (mounted) {
      // Restart the app by replacing the entire widget tree
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MyApp()),
        (route) => false,
      );
    }
  }
}
