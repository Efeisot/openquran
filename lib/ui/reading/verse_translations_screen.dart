import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import '../../data/repository/quran_repository.dart';
import '../../main.dart';

final verseTranslationsProvider =
    FutureProvider.family<
      List<TranslationWithAuthor>,
      ({int surahId, int verseNumber})
    >((ref, args) {
      final repository = ref.watch(quranRepositoryProvider);
      return repository.getTranslationsForVerse(args.surahId, args.verseNumber);
    });

class VerseTranslationsScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final translationsAsync = ref.watch(
      verseTranslationsProvider((surahId: surahId, verseNumber: verseNumber)),
    );
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Don't set backgroundColor here - let it use theme default which respects AMOLED
        appBar: AppBar(
          // Don't set backgroundColor - use theme default
          title: Text(
            '${surahId}. ${l10n.surah}, ${verseNumber}. ${l10n.verse}',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          iconTheme: IconThemeData(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
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
                    // Translations List
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = translations[index];
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
                                      child: Text(
                                        item.author.name,
                                        style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.7),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    // Icons like screenshot (Sound, etc - placeholders)
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
                        }, childCount: translations.length),
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
              surahId: surahId,
              verseNumber: verseNumber,
              verseText: verseText,
            ),
          ],
        ),
      ),
    );
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
    final l10n = AppLocalizations.of(context)!;

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
