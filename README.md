# openQuran

An open-source, modern Quran reading app built with Flutter featuring multiple translations, word-by-word analysis, and a beautiful Material Design 3 interface.

## Features

- **📖 Complete Quran Text**: Read all 114 surahs with Arabic text and transcription
- **🌍 Multiple Translations**: Access various translations in different languages
- **📝 Word-by-Word Analysis**: Understand each word with detailed translations and transcriptions  
- **🔖 Notes & Bookmarks**: Save personal notes for any verse
- **🎨 Material Design 3**: Beautiful, modern UI with Material You support
- **🌙 AMOLED Mode**: Pure black theme optimized for AMOLED displays
- **🌐 Multi-language Support**: Available in English and Turkish
- **📱 Offline Support**: Browse surahs and read previously loaded content offline
- **⚡ Continue Reading**: Quickly resume from where you left off

## Screenshots

*(Screenshots will be added here)*

## Building from Source

### Prerequisites

- Flutter SDK (^3.10.1)
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions
- Android SDK for Android builds

### Setup

 1. **Clone the repository**:
   ```bash
   git clone https://github.com/efeisot/openQuran.git
   cd openQuran
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate localization files**:
   ```bash
   flutter gen-l10n
   ```

4. **Run code generation** (for Drift database and Riverpod):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

### Building Release APK

```bash
flutter build apk --release
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Database**: Drift (SQLite)
- **Networking**: Dio
- **Localization**: flutter_localizations with ARB files
- **Theming**: Material Design 3 with Dynamic Color support

## Project Structure

```
lib/
├── data/
│   ├── local/       # Database and local preferences
│   ├── remote/      # API client
│   └── repository/  # Data repository layer
├── l10n/            # Localization files (ARB)
├── ui/
│   ├── home/        # Home screen
│   ├── onboarding/  # Onboarding flow
│   ├── reading/     # Quran reading screens
│   ├── settings/    # Settings screen
│   └── theme/       # Theme configuration
└── main.dart        # App entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines

1. Follow the existing code style and structure
2. Add tests for new features when applicable
3. Update documentation as needed
4. Ensure all tests pass before submitting PR

## API

This app uses a Quran API for fetching surah data, translations, and word-by-word analysis. The API client is located in `lib/data/remote/api_client.dart`.

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- Quran data and translations from various Islamic sources
- Arabic font: Amiri
- Flutter and the Flutter community
- All contributors and testers

##  Contact

- **Repository**: [github.com/efeisot/openQuran](https://github.com/efeisot/openQuran)
- **Issues**: [github.com/efeisot/openQuran/issues](https://github.com/efeisot/openQuran/issues)

## Version

**Current Version**: v1.0-beta

---

Made with ❤️ for the Muslim community
