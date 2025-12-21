import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'repository/quran_repository.dart';

part 'download_manager.g.dart';

@riverpod
DownloadManager downloadManager(Ref ref) {
  return DownloadManager(ref.watch(quranRepositoryProvider));
}

class DownloadProgress {
  final int currentSurah;
  final int totalSurahs;
  final int authorId;
  final bool isComplete;
  final String? error;
  final bool isCancelled;

  DownloadProgress({
    required this.currentSurah,
    required this.totalSurahs,
    required this.authorId,
    this.isComplete = false,
    this.error,
    this.isCancelled = false,
  });

  double get progress => totalSurahs > 0 ? currentSurah / totalSurahs : 0.0;
}

class DownloadManager {
  final QuranRepository _repository;
  final _progressController = StreamController<DownloadProgress>.broadcast();
  final Map<int, bool> _cancelFlags = {};

  DownloadManager(this._repository);

  Stream<DownloadProgress> get progressStream => _progressController.stream;

  Future<void> downloadTranslation(int authorId, String authorName) async {
    _cancelFlags[authorId] = false;

    try {
      final surahs = await _repository.getSurahs();
      final totalSurahs = surahs.length;
      int totalVerses = 0;

      for (int i = 0; i < surahs.length; i++) {
        // Check if cancelled
        if (_cancelFlags[authorId] == true) {
          _progressController.add(
            DownloadProgress(
              currentSurah: i,
              totalSurahs: totalSurahs,
              authorId: authorId,
              isCancelled: true,
            ),
          );
          return;
        }

        final surah = surahs[i];

        // Update progress
        _progressController.add(
          DownloadProgress(
            currentSurah: i + 1,
            totalSurahs: totalSurahs,
            authorId: authorId,
          ),
        );

        try {
          // Sync surah details (downloads verses)
          await _repository.syncSurahDetails(surah.id);

          // Get verses to count them
          final surahDetails = await _repository.getSurahDetails(surah.id);
          totalVerses += surahDetails.verses.length;

          // Download translations for each verse
          for (final verse in surahDetails.verses) {
            if (_cancelFlags[authorId] == true) {
              _progressController.add(
                DownloadProgress(
                  currentSurah: i,
                  totalSurahs: totalSurahs,
                  authorId: authorId,
                  isCancelled: true,
                ),
              );
              return;
            }

            // Cache the specific author's translation for this verse
            await _repository.cacheTranslationForVerse(
              surahId: surah.id,
              verseNumber: verse.verseNumber,
              authorId: authorId,
            );
          }
        } catch (e) {
          print('Error downloading surah ${surah.id}: $e');
          // Continue with next surah on error
          continue;
        }
      }

      // Mark as downloaded
      await _repository.saveDownloadedTranslation(
        authorId: authorId,
        authorName: authorName,
        totalVerses: totalVerses,
      );

      // Send completion event
      _progressController.add(
        DownloadProgress(
          currentSurah: totalSurahs,
          totalSurahs: totalSurahs,
          authorId: authorId,
          isComplete: true,
        ),
      );
    } catch (e) {
      _progressController.add(
        DownloadProgress(
          currentSurah: 0,
          totalSurahs: 114,
          authorId: authorId,
          error: e.toString(),
        ),
      );
    } finally {
      _cancelFlags.remove(authorId);
    }
  }

  void cancelDownload(int authorId) {
    _cancelFlags[authorId] = true;
  }

  Future<void> deleteTranslation(int authorId) async {
    await _repository.deleteDownloadedTranslation(authorId);
  }

  Future<bool> isTranslationDownloaded(int authorId) {
    return _repository.isTranslationDownloaded(authorId);
  }

  void dispose() {
    _progressController.close();
  }
}
