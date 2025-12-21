import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_quran/l10n/app_localizations.dart';
import '../../data/repository/quran_repository.dart';
import '../../data/local/preferences.dart';
import '../../main.dart';

final verseTranslationsProvider =
    FutureProvider.family<
      List<TranslationWithAuthor>,
      ({int surahId, int verseNumber})
    >((ref, args) {
      final repository = ref.watch(quranRepositoryProvider);
      return repository.getTranslationsForVerse(args.surahId, args.verseNumber);
    });

class VerseTranslationsScreen extends ConsumerStatefulWidget {
  final int surahId;
  final int verseNumber;
  final String verseText;

  const VerseTranslationsScreen({
    super.key,
    required this.surahId,
    required this.verseNumber,
    required this.verseText,
  });

  @override
  ConsumerState<VerseTranslationsScreen> createState() =>
      _VerseTranslationsScreenState();
}

class _VerseTranslationsScreenState
    extends ConsumerState<VerseTranslationsScreen> {
  late int currentSurahId;
  late int currentVerseNumber;
  late String currentVerseText;

  @override
  void initState() {
    super.initState();
    currentSurahId = widget.surahId;
    currentVerseNumber = widget.verseNumber;
    currentVerseText = widget.verseText;
  }

  void _navigateToPrevious() async {
    if (currentVerseNumber > 1) {
      // Previous verse in same surah
      final repository = ref.read(quranRepositoryProvider);
      final surahData = await repository.getSurahDetails(currentSurahId);
      final prevVerse = surahData.verses.firstWhere(
        (v) => v.verseNumber == currentVerseNumber - 1,
      );

      setState(() {
        currentVerseNumber = prevVerse.verseNumber;
        currentVerseText = prevVerse.verse;
      });
    } else if (currentSurahId > 1) {
      // Last verse of previous surah
      final repository = ref.read(quranRepositoryProvider);
      final prevSurahData = await repository.getSurahDetails(
        currentSurahId - 1,
      );
      final lastVerse = prevSurahData.verses.last;

      setState(() {
        currentSurahId--;
        currentVerseNumber = lastVerse.verseNumber;
        currentVerseText = lastVerse.verse;
      });
    }
  }

  void _navigateToNext() async {
    final repository = ref.read(quranRepositoryProvider);
    final surahData = await repository.getSurahDetails(currentSurahId);

    if (currentVerseNumber < surahData.surah.verseCount) {
      // Next verse in same surah
      final nextVerse = surahData.verses.firstWhere(
        (v) => v.verseNumber == currentVerseNumber + 1,
      );

      setState(() {
        currentVerseNumber = nextVerse.verseNumber;
        currentVerseText = nextVerse.verse;
      });
    } else if (currentSurahId < 114) {
      // First verse of next surah
      final nextSurahData = await repository.getSurahDetails(
        currentSurahId + 1,
      );
      final firstVerse = nextSurahData.verses.first;

      setState(() {
        currentSurahId++;
        currentVerseNumber = firstVerse.verseNumber;
        currentVerseText = firstVerse.verse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationsAsync = ref.watch(
      verseTranslationsProvider((
        surahId: currentSurahId,
        verseNumber: currentVerseNumber,
      )),
    );
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final defaultAuthorId = ref
        .watch(preferencesProvider)
        .getDefaultTranslationAuthorId();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${currentSurahId}. ${l10n.surah}, ${currentVerseNumber}. ${l10n.verse}',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          iconTheme: IconThemeData(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: (currentSurahId == 1 && currentVerseNumber == 1)
                  ? null
                  : _navigateToPrevious,
              tooltip: l10n.previousVerse,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: (currentSurahId == 114 && currentVerseNumber >= 6)
                  ? null
                  : _navigateToNext,
              tooltip: l10n.nextVerse,
            ),
          ],
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.onSurface,
            unselectedLabelColor: colorScheme.onSurface.withOpacity(0.4),
            tabs: [
              Tab(text: l10n.translations),
              Tab(text: l10n.words),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Translations Tab
            translationsAsync.when(
              data: (translations) {
                if (translations.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noTranslationsFound,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  );
                }

                // Reorder translations to show default first
                final reorderedTranslations = _reorderTranslations(
                  translations,
                  defaultAuthorId,
                );

                return CustomScrollView(
                  slivers: [
                    // Arabic Verse Header
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 150),
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SelectableText(
                                  currentVerseText,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 20,
                                    height: 1.6,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: colorScheme.onSurface.withOpacity(0.1),
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                    // Translations List
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = reorderedTranslations[index];
                          final isDefault =
                              defaultAuthorId != null &&
                              item.author.id == defaultAuthorId;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(
                                            item.author.name,
                                            style: TextStyle(
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          if (isDefault) ...[
                                            const SizedBox(width: 8),
                                            Icon(
                                              Icons.star,
                                              size: 16,
                                              color: colorScheme.primary,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.volume_up_outlined,
                                      size: 16,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.translation.content,
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Divider(
                                  color: colorScheme.onSurface.withOpacity(0.1),
                                ),
                              ],
                            ),
                          );
                        }, childCount: reorderedTranslations.length),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ),
            // Words Tab
            _WordsTabView(
              surahId: currentSurahId,
              verseNumber: currentVerseNumber,
              verseText: currentVerseText,
            ),
          ],
        ),
      ),
    );
  }

  List<TranslationWithAuthor> _reorderTranslations(
    List<TranslationWithAuthor> translations,
    int? defaultAuthorId,
  ) {
    if (defaultAuthorId == null) return translations;

    final defaultTranslation = translations
        .where((t) => t.author.id == defaultAuthorId)
        .toList();
    final otherTranslations = translations
        .where((t) => t.author.id != defaultAuthorId)
        .toList();

    return [...defaultTranslation, ...otherTranslations];
  }
}

final _verseWordsProvider =
    FutureProvider.family<List<VerseWord>, ({int surahId, int verseNumber})>((
      ref,
      args,
    ) {
      final repository = ref.watch(quranRepositoryProvider);
      return repository.getVerseWords(args.surahId, args.verseNumber);
    });

class _WordsTabView extends ConsumerWidget {
  final int surahId;
  final int verseNumber;
  final String verseText;

  const _WordsTabView({
    required this.surahId,
    required this.verseNumber,
    required this.verseText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(
      _verseWordsProvider((surahId: surahId, verseNumber: verseNumber)),
    );
    final colorScheme = Theme.of(context).colorScheme;

    return wordsAsync.when(
      data: (words) {
        if (words.isEmpty) {
          return Center(
            child: Text(
              'No word data available',
              style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            ),
          );
        }
        return CustomScrollView(
          slivers: [
            // Arabic Verse Header
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SelectableText(
                          verseText,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 20,
                            height: 1.6,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: colorScheme.onSurface.withOpacity(0.1),
                    height: 1,
                  ),
                ],
              ),
            ),
            // Words List
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final word = words[index];
                  // Get translation based on app language setting, not system locale
                  final currentLocale = ref.watch(localeProvider);
                  final isTurkish = currentLocale?.languageCode == 'tr';
                  final translation = isTurkish
                      ? word.translationTr
                      : word.translationEn;
                  final transcription = isTurkish
                      ? word.transcriptionTr
                      : word.transcriptionEn;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Arabic word
                          Text(
                            word.arabic,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 24,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          if (transcription != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              transcription,
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                          if (translation != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              translation,
                              style: TextStyle(
                                fontSize: 14,
                                color: colorScheme.onSurface.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }, childCount: words.length),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text(
          'Error loading words: $err',
          style: TextStyle(color: colorScheme.error),
        ),
      ),
    );
  }
}
