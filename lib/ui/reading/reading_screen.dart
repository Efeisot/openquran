import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import '../../data/repository/quran_repository.dart';
import '../../data/local/database.dart';
import '../../data/local/preferences.dart';
import 'verse_translations_screen.dart';

final surahNotesProvider = FutureProvider.family<List<Note>, int>((
  ref,
  surahId,
) {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getNotes(surahId);
});

class ReadingScreen extends ConsumerStatefulWidget {
  final int surahId;
  final bool shouldAutoOpen; // Whether to auto-open the last read verse

  const ReadingScreen({
    super.key,
    required this.surahId,
    this.shouldAutoOpen = false, // Default to false
  });

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentVerseNumber = 1;

  @override
  void initState() {
    super.initState();
    // Save last read surah when opening and scroll to last verse
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prefs = ref.read(preferencesProvider);
      final lastReadData = prefs.getLastRead();

      // If this is the last read surah and we have a verse number > 1, scroll to it
      if (lastReadData != null) {
        final lastSurah = lastReadData.$1;
        final lastVerse = lastReadData.$2;

        if (lastSurah == widget.surahId && lastVerse > 1) {
          _currentVerseNumber = lastVerse;
          // Only auto-open if explicitly requested (from Continue Reading button)
          if (widget.shouldAutoOpen) {
            // Scroll to the verse and then auto-open it
            Future.delayed(const Duration(milliseconds: 100), () {
              if (_scrollController.hasClients && mounted) {
                // Use accurate calculation: 230px per card
                final position = (lastVerse - 1) * 230.0;
                _scrollController.jumpTo(
                  position.clamp(
                    0.0,
                    _scrollController.position.maxScrollExtent,
                  ),
                );

                // Auto-open the verse immediately after scrolling
                Future.delayed(const Duration(milliseconds: 50), () {
                  if (mounted) {
                    // Find the verse data and open it
                    final surahAsync = ref.read(
                      surahDetailsProvider(widget.surahId),
                    );
                    surahAsync.whenData((data) {
                      final verse = data.verses.firstWhere(
                        (v) => v.verseNumber == lastVerse,
                        orElse: () => data.verses.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerseTranslationsScreen(
                            surahId: widget.surahId,
                            verseNumber: verse.verseNumber,
                            verseText: verse.verse,
                          ),
                        ),
                      );
                    });
                  }
                });
              }
            });
          } else {
            // Just scroll, don't auto-open
            Future.delayed(const Duration(milliseconds: 100), () {
              if (_scrollController.hasClients && mounted) {
                final position = (lastVerse - 1) * 230.0;
                _scrollController.jumpTo(
                  position.clamp(
                    0.0,
                    _scrollController.position.maxScrollExtent,
                  ),
                );
              }
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    // Save last position when leaving the screen with current verse
    ref
        .read(preferencesProvider)
        .setLastRead(widget.surahId, _currentVerseNumber);
    _scrollController.dispose();
    super.dispose();
  }

  void _showNoteDialog(
    BuildContext context,
    int verseNumber,
    String? existingNote,
  ) {
    final controller = TextEditingController(text: existingNote);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Note - ${AppLocalizations.of(context)!.verse} $verseNumber',
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterNote,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              final repository = ref.read(quranRepositoryProvider);
              if (controller.text.isEmpty) {
                // Delete note if empty
                final existingNote = await repository.getNoteForVerse(
                  widget.surahId,
                  verseNumber,
                );
                if (existingNote != null) {
                  await repository.deleteNote(existingNote.id);
                }
              } else {
                // Save note if has content
                await repository.saveNote(
                  widget.surahId,
                  verseNumber,
                  controller.text,
                );
              }
              ref.invalidate(surahNotesProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surahAsync = ref.watch(surahDetailsProvider(widget.surahId));
    final notesAsync = ref.watch(surahNotesProvider(widget.surahId));

    return Scaffold(
      appBar: AppBar(
        title: surahAsync.when(
          data: (data) => Text(
            '${data.surah.id}. ${data.surah.nameEn}',
            style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
          ),
          loading: () => const Text('...'),
          error: (_, __) => const Text('Error'),
        ),
      ),
      body: surahAsync.when(
        data: (data) {
          final notes = notesAsync.value ?? [];
          return ListView.builder(
            controller: _scrollController,
            itemCount: data.verses.length,
            itemBuilder: (context, index) {
              final verse = data.verses[index];
              final hasNote = notes.any(
                (n) => n.verseNumber == verse.verseNumber,
              );
              final note = notes.firstWhere(
                (n) => n.verseNumber == verse.verseNumber,
                orElse: () => Note(
                  id: 0,
                  surahId: widget.surahId,
                  verseNumber: verse.verseNumber,
                  content: null,
                  createdAt: DateTime.now(),
                ),
              );

              return Card(
                key: ValueKey(verse.verseNumber),
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // Update current verse number and save position
                    setState(() {
                      _currentVerseNumber = verse.verseNumber;
                    });
                    ref
                        .read(preferencesProvider)
                        .setLastRead(widget.surahId, verse.verseNumber);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerseTranslationsScreen(
                          surahId: widget.surahId,
                          verseNumber: verse.verseNumber,
                          verseText: verse.verse,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    // Update current verse number and save position
                    setState(() {
                      _currentVerseNumber = verse.verseNumber;
                    });
                    ref
                        .read(preferencesProvider)
                        .setLastRead(widget.surahId, verse.verseNumber);
                    _showNoteDialog(context, verse.verseNumber, note.content);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              child: Text(
                                '${verse.verseNumber}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            if (hasNote)
                              Icon(
                                Icons.note_alt,
                                size: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SelectableText(
                          verse.verse,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 20,
                            height: 1.8,
                          ),
                        ),
                        if (verse.transcription != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            verse.transcription!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

final surahDetailsProvider = FutureProvider.family<SurahWithVerses, int>((
  ref,
  surahId,
) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getSurahDetails(surahId);
});
