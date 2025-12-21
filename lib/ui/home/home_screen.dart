import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/quran_repository.dart';
import '../../data/local/database.dart';
import '../reading/reading_screen.dart';
import '../settings/settings_screen.dart';
import 'package:open_quran/l10n/app_localizations.dart';
import '../reading/saved_verses_screen.dart';
import '../../data/local/preferences.dart';
import '../search/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surahsAsync = ref.watch(surahsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(l10n.savedVerses),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedVersesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(l10n.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: surahsAsync.when(
        data: (surahs) => ListView.builder(
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final surah = surahs[index];
            return ListTile(
              leading: CircleAvatar(child: Text('${surah.id}')),
              title: Text(surah.name),
              subtitle: Text(
                '${surah.nameEn} - ${surah.verseCount} ${l10n.verses}',
              ),
              trailing: Text(
                surah.nameOriginal,
                style: const TextStyle(fontFamily: 'Amiri'),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReadingScreen(surahId: surah.id),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final lastRead = ref.read(preferencesProvider).getLastRead();
          final surahId =
              lastRead?.$1 ?? 1; // Default to Fatiha if no last read
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadingScreen(
                surahId: surahId,
                shouldAutoOpen: true, // Auto-open the verse
              ),
            ),
          );
        },
        icon: const Icon(Icons.menu_book),
        label: Text(l10n.continueReading),
      ),
    );
  }
}

final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getSurahs();
});
