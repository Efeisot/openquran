import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_quran/l10n/app_localizations.dart';
import 'package:open_quran/data/local/preferences.dart';
import '../../data/repository/quran_repository.dart';
import '../../main.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isRefreshing = false;

  Future<void> _refreshData(BuildContext context) async {
    setState(() => _isRefreshing = true);
    try {
      // Clear database tables
      final db = ref.read(appDatabaseProvider);
      await db.delete(db.surahs).go();
      await db.delete(db.verses).go();
      await db.delete(db.translations).go();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.dataClearedMessage +
                  '\n${AppLocalizations.of(context)!.language == 'tr' ? 'Lütfen uygulamayı yeniden başlatın.' : 'Please restart the application.'}',
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.theme),
            subtitle: Text(themeMode.name.toUpperCase()),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              onChanged: (ThemeMode? newValue) {
                if (newValue != null) {
                  ref.read(themeModeProvider.notifier).setMode(newValue);
                }
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(l10n.system),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(l10n.light),
                ),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.dark)),
              ],
            ),
          ),
          SwitchListTile(
            title: Text(l10n.amoledMode),
            value: ref.watch(amoledModeProvider),
            onChanged: (bool value) {
              ref.read(amoledModeProvider.notifier).setMode(value);
            },
          ),
          SwitchListTile(
            title: Text(l10n.materialYou),
            subtitle: Text(l10n.useSystemColors),
            value: ref.watch(materialYouProvider),
            onChanged: (bool value) {
              ref.read(materialYouProvider.notifier).setEnabled(value);
            },
          ),
          ListTile(
            title: Text(l10n.language),
            subtitle: Text(locale?.languageCode.toUpperCase() ?? l10n.system),
            trailing: DropdownButton<Locale>(
              value: locale,
              onChanged: (Locale? newValue) {
                if (newValue != null) {
                  ref.read(localeProvider.notifier).setLocale(newValue);
                }
              },
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('tr'), child: Text('Türkçe')),
              ],
            ),
          ),
          const Divider(),
          // Default Translation
          FutureBuilder(
            future: ref.read(quranRepositoryProvider).getAuthors(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return ListTile(title: Text(l10n.defaultTranslation));
              }
              final authors = snapshot.data!;
              final currentAuthorId = ref
                  .read(preferencesProvider)
                  .getDefaultTranslationAuthorId();
              final currentAuthor = authors
                  .where((a) => a.id == currentAuthorId)
                  .firstOrNull;

              return ListTile(
                title: Text(l10n.defaultTranslation),
                subtitle: currentAuthor != null ? null : Text(l10n.none),
                trailing: DropdownButton<int?>(
                  value: currentAuthorId,
                  onChanged: (int? authorId) {
                    ref
                        .read(preferencesProvider)
                        .setDefaultTranslationAuthorId(authorId);
                    setState(() {}); // Refresh to update subtitle
                  },
                  items: [
                    DropdownMenuItem<int?>(value: null, child: Text(l10n.none)),
                    ...authors.map(
                      (author) => DropdownMenuItem<int?>(
                        value: author.id,
                        child: Text(author.name),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          // Credits Section
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(l10n.credits),
          ),
          // Source Code
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(l10n.sourceCode),
            subtitle: const Text('github.com/efeisot/openQuran'),
            onTap: () async {
              final url = Uri.parse('https://github.com/efeisot/openQuran');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          // API Provider
          ListTile(
            leading: const Icon(Icons.api),
            title: Text(l10n.apiProvider),
            subtitle: Text(l10n.apiCredit),
            onTap: () async {
              final url = Uri.parse(
                'https://github.com/ziegfiroyt/acikkuran-api',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
          ),
          // Version
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            subtitle: const Text('v1.1-beta'),
          ),
          const Divider(),
          const Divider(),
          ListTile(
            leading: _isRefreshing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            title: Text(l10n.refreshData),
            subtitle: Text(l10n.clearCacheSubtitle),
            enabled: !_isRefreshing,
            onTap: _isRefreshing
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.refreshDataTitle),
                        content: Text(l10n.refreshDataMessage),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.refresh),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await _refreshData(context);
                    }
                  },
          ),
        ],
      ),
    );
  }
}
