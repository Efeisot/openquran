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

<details>
  <summary><b>📸 Click to see all screenshots</b></summary>
  <br>
  <p align="center">
      <img src="https://github.com/user-attachments/assets/bca32d35-1a3a-4099-8884-aad0d09aad03" width="200" alt="00-11-54">
      <img src="https://github.com/user-attachments/assets/619449e1-1553-481c-9fce-42f26343c81b" width="200" alt="00-12-06">
      <img src="https://github.com/user-attachments/assets/28daf0c3-c1af-412c-b521-a5dbb033f2d4" width="200" alt="00-12-10">
      <img src="https://github.com/user-attachments/assets/86bb40a6-96de-4152-a365-2831a8bc231d" width="200" alt="00-12-13">
      <img src="https://github.com/user-attachments/assets/1a3394a9-d564-45fd-aa1c-7ac0a6b6aaa5" width="200" alt="00-12-16">
      <img src="https://github.com/user-attachments/assets/f709451a-ec41-4490-943e-f6bed94bcb74" width="200" alt="00-12-18">
      <img src="https://github.com/user-attachments/assets/5e49bfb3-8279-44b7-a8da-df7411fc35d0" width="200" alt="00-12-21">
      <img src="https://github.com/user-attachments/assets/56f5cdbc-a46a-429d-ae63-3e77348610a7" width="200" alt="00-12-23">
      <img src="https://github.com/user-attachments/assets/b1b82ff4-3e82-4dbf-98d0-8ec972ad93eb" width="200" alt="00-12-26">
      <img src="https://github.com/user-attachments/assets/6ab3cd30-1bc6-494f-96c4-7c2e872d2f56" width="200" alt="00-12-29">
      <img src="https://github.com/user-attachments/assets/0babb93e-ffc5-48bd-8c09-353591b1520a" width="200" alt="00-12-32">
      <img src="https://github.com/user-attachments/assets/d52880ec-cdb6-45b4-a9c3-48f466069949" width="200" alt="00-12-35">
      <img src="https://github.com/user-attachments/assets/c1f8d283-8445-43c8-87ae-48218982c6e2" width="200" alt="00-12-38">
      <img src="https://github.com/user-attachments/assets/45edd65c-4994-44d5-ba01-b92a68bb9587" width="200" alt="00-12-40">
      <img src="https://github.com/user-attachments/assets/720e9346-3083-459c-9f37-71f63cdf3d8d" width="200" alt="00-12-44">
      <img src="https://github.com/user-attachments/assets/528cd58a-4e17-4c87-9305-75732f444156" width="200" alt="00-12-46">
      <img src="https://github.com/user-attachments/assets/52af8ef0-1c3d-4085-97a8-8bb4529c3ca1" width="200" alt="00-12-49">
  </p>
</details>

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

This project is open source and available under the [GNU Affero General Public License v3.0 (AGPL-3.0)](LICENSE).

## Acknowledgments

- Quran data and translations from various Islamic sources
- Arabic font: Amiri
- Flutter and the Flutter community
- All contributors and testers

##  Contact

- **Repository**: [github.com/efeisot/openQuran](https://github.com/efeisot/openQuran)
- **Issues**: [github.com/efeisot/openQuran/issues](https://github.com/efeisot/openQuran/issues)

## Thanks To
- [acik-kuran](https://github.com/acik-kuran) for api
- [SavunOski](https://github.com/savunoski) for help
- Gemini Pro and Claude Sonnet/Opus for writing most of the lines

## Version

**Current Version**: v1.1-beta

---

Made with patience, for the Muslim community
