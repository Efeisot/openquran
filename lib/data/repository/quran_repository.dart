import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../local/database.dart';
import '../remote/api_client.dart';

part 'quran_repository.g.dart';

@riverpod
QuranRepository quranRepository(Ref ref) {
  return QuranRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(apiClientProvider),
  );
}

@riverpod
AppDatabase appDatabase(Ref ref) => AppDatabase();

class QuranRepository {
  final AppDatabase _db;
  final ApiClient _api;

  QuranRepository(this._db, this._api);

  Future<List<Surah>> getSurahs() async {
    final localSurahs = await _db.select(_db.surahs).get();
    if (localSurahs.isEmpty) {
      await syncSurahs();
      return _db.select(_db.surahs).get();
    }
    return localSurahs;
  }

  Future<void> syncSurahs() async {
    final surahsData = await _api.getSurahs();
    await _db.batch((batch) {
      batch.insertAll(
        _db.surahs,
        surahsData.map(
          (data) => SurahsCompanion.insert(
            id: Value(data['id']),
            name: data['name'],
            nameEn: data['name_en'],
            nameOriginal: data['name_original'],
            slug: data['slug'],
            verseCount: data['verse_count'],
            pageNumber: data['page_number'],
            audio: Value(data['audio']['mp3']),
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<SurahWithVerses> getSurahDetails(int surahId) async {
    final surah = await (_db.select(
      _db.surahs,
    )..where((t) => t.id.equals(surahId))).getSingle();
    final verses = await (_db.select(
      _db.verses,
    )..where((t) => t.surahId.equals(surahId))).get();

    if (verses.isEmpty) {
      await syncSurahDetails(surahId);
      final newVerses = await (_db.select(
        _db.verses,
      )..where((t) => t.surahId.equals(surahId))).get();
      return SurahWithVerses(surah, newVerses);
    }

    return SurahWithVerses(surah, verses);
  }

  Future<void> syncAuthors() async {
    final authorsData = await _api.getAuthors();
    await _db.batch((batch) {
      batch.insertAll(
        _db.authors,
        authorsData.map(
          (data) => AuthorsCompanion.insert(
            id: Value(data['id']),
            name: data['name'],
            description: Value(data['description']),
            language: data['language'],
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<List<Author>> getAuthors() async {
    final localAuthors = await _db.select(_db.authors).get();
    if (localAuthors.isEmpty) {
      try {
        await syncAuthors();
        return _db.select(_db.authors).get();
      } catch (e) {
        // If sync fails (offline), return empty list or throw
        // This allows the UI to show error state
        print('Failed to sync authors (possibly offline): $e');
        rethrow;
      }
    }
    return localAuthors;
  }

  Future<void> syncSurahDetails(int surahId) async {
    final data = await _api.getSurah(surahId);
    final versesData = data['verses'] as List;

    await _db.batch((batch) {
      batch.insertAll(
        _db.verses,
        versesData.map(
          (v) => VersesCompanion.insert(
            id: Value(v['id']), // Explicitly use API ID
            surahId: surahId,
            verseNumber: v['verse_number'],
            verse: v['verse'],
            verseSimplified: Value(v['verse_simplified']),
            page: v['page'],
            juzNumber: v['juz_number'],
            transcription: Value(v['transcription']),
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<List<TranslationWithAuthor>> getTranslationsForVerse(
    int surahId,
    int verseNumber,
  ) async {
    try {
      // Try to fetch from API first
      final translationsData = await _api.getVerseTranslations(
        surahId,
        verseNumber,
      );

      final results = translationsData.map<TranslationWithAuthor>((data) {
        final author = Author(
          id: data['author']['id'],
          name: data['author']['name'],
          description: data['author']['description'],
          language: data['author']['language'],
        );

        final translation = Translation(
          id: data['id'],
          verseId: 0,
          authorId: data['author']['id'],
          content: data['text'],
        );

        return TranslationWithAuthor(translation, author);
      }).toList();

      // Cache the results for offline use
      await _cacheTranslations(surahId, verseNumber, translationsData);

      return results;
    } catch (e) {
      // Fallback 1: Try to load from cached translations
      final cached = await _getCachedTranslations(surahId, verseNumber);

      // Fallback 2: Try to load from downloaded translations
      final downloaded = await _getDownloadedTranslations(surahId, verseNumber);

      // Combine and deduplicate by author ID
      final allTranslations = [...cached, ...downloaded];
      final seenAuthorIds = <int>{};
      final deduplicated = <TranslationWithAuthor>[];

      for (final trans in allTranslations) {
        if (!seenAuthorIds.contains(trans.author.id)) {
          seenAuthorIds.add(trans.author.id);
          deduplicated.add(trans);
        }
      }

      return deduplicated;
    }
  }

  Future<void> _cacheTranslations(
    int surahId,
    int verseNumber,
    List<dynamic> translationsData,
  ) async {
    try {
      await _db.batch((batch) {
        batch.insertAll(
          _db.cachedTranslations,
          translationsData.map(
            (data) => CachedTranslationsCompanion.insert(
              surahId: surahId,
              verseNumber: verseNumber,
              authorId: data['author']['id'],
              authorName: data['author']['name'],
              authorDescription: Value(data['author']['description']),
              authorLanguage: data['author']['language'],
              content: data['text'],
            ),
          ),
          mode: InsertMode.insertOrReplace,
        );
      });
    } catch (e) {
      // Silently fail - caching is best-effort
    }
  }

  Future<List<TranslationWithAuthor>> _getCachedTranslations(
    int surahId,
    int verseNumber,
  ) async {
    final cached =
        await (_db.select(_db.cachedTranslations)..where(
              (t) =>
                  t.surahId.equals(surahId) & t.verseNumber.equals(verseNumber),
            ))
            .get();

    return cached.map((c) {
      final author = Author(
        id: c.authorId,
        name: c.authorName,
        description: c.authorDescription,
        language: c.authorLanguage,
      );

      final translation = Translation(
        id: 0,
        verseId: 0,
        authorId: c.authorId,
        content: c.content,
      );

      return TranslationWithAuthor(translation, author);
    }).toList();
  }

  // Query downloaded translations from the separate DatabaseHelper database
  Future<List<TranslationWithAuthor>> _getDownloadedTranslations(
    int surahId,
    int verseNumber,
  ) async {
    try {
      // Open the downloaded translations database
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'quran_translations.db');

      // Check if database exists first
      final dbFile = File(path);
      if (!await dbFile.exists()) {
        return [];
      }

      final db = await openDatabase(path);

      try {
        // Get list of downloaded author IDs
        final downloadedAuthors = await db.query('downloaded_authors');
        if (downloadedAuthors.isEmpty) {
          return [];
        }

        final authorIds = downloadedAuthors
            .map((a) => a['author_id'] as int)
            .toList();

        //Fix SQL query to handle empty list properly
        if (authorIds.isEmpty) return [];

        // Build IN clause manually to avoid SQL injection
        final placeholders = List.filled(authorIds.length, '?').join(',');

        // Get translations for this verse from downloaded authors
        final verses = await db.query(
          'verses',
          where:
              'surah_id = ? AND verse_number = ? AND author_id IN ($placeholders)',
          whereArgs: [surahId, verseNumber, ...authorIds],
        );

        if (verses.isEmpty) {
          return [];
        }

        // Get author details from AppDatabase for each verse
        final results = <TranslationWithAuthor>[];
        for (final v in verses) {
          final authorId = v['author_id'] as int;

          // Try to get author from local database
          final author = await (_db.select(
            _db.authors,
          )..where((t) => t.id.equals(authorId))).getSingleOrNull();

          if (author != null) {
            results.add(
              TranslationWithAuthor(
                Translation(
                  id: 0,
                  verseId: 0,
                  authorId: authorId,
                  content: v['text'] as String,
                ),
                author,
              ),
            );
          } else {
            // Author not found in AppDatabase - need to sync authors first
            print(
              'Warning: Author $authorId found in downloads but not in AppDatabase',
            );
          }
        }

        return results;
      } finally {
        await db.close();
      }
    } catch (e) {
      // Return empty list if downloaded translations database doesn't exist or query fails
      print('Error loading downloaded translations: $e');
      return [];
    }
  }

  Future<String?> getDefaultTranslationForVerse(
    int surahId,
    int verseNumber,
    int authorId,
  ) async {
    try {
      // Try API first
      final translationsData = await _api.getVerseTranslations(
        surahId,
        verseNumber,
      );

      // Cache for offline use
      await _cacheTranslations(surahId, verseNumber, translationsData);

      // Find the translation for the specified author
      final authorTranslation = translationsData.firstWhere(
        (data) => data['author']['id'] == authorId,
        orElse: () => {},
      );

      if (authorTranslation.isEmpty) return null;
      return authorTranslation['text'] as String?;
    } catch (e) {
      // Fallback to cache
      final cached =
          await (_db.select(_db.cachedTranslations)..where(
                (t) =>
                    t.surahId.equals(surahId) &
                    t.verseNumber.equals(verseNumber) &
                    t.authorId.equals(authorId),
              ))
              .getSingleOrNull();
      return cached?.content;
    }
  }

  Future<List<VerseWord>> getVerseWords(int surahId, int verseNumber) async {
    try {
      // Try API first
      final wordsData = await _api.getVerseWords(surahId, verseNumber);
      final results = wordsData.map<VerseWord>((data) {
        return VerseWord(
          arabic: data['arabic'] as String,
          transcriptionTr: data['transcription_tr'] as String?,
          transcriptionEn: data['transcription_en'] as String?,
          translationTr: data['translation_tr'] as String?,
          translationEn: data['translation_en'] as String?,
          sortNumber: data['sort_number'] as int,
        );
      }).toList();

      // Cache for offline use
      await _cacheVerseWords(surahId, verseNumber, wordsData);

      return results;
    } catch (e) {
      // Fallback to cache
      return _getCachedVerseWords(surahId, verseNumber);
    }
  }

  Future<void> _cacheVerseWords(
    int surahId,
    int verseNumber,
    List<dynamic> wordsData,
  ) async {
    try {
      // First delete existing cached words for this verse
      await (_db.delete(_db.cachedVerseWords)..where(
            (t) =>
                t.surahId.equals(surahId) & t.verseNumber.equals(verseNumber),
          ))
          .go();

      // Insert new words
      await _db.batch((batch) {
        batch.insertAll(
          _db.cachedVerseWords,
          wordsData.map(
            (data) => CachedVerseWordsCompanion.insert(
              surahId: surahId,
              verseNumber: verseNumber,
              arabic: data['arabic'] as String,
              transcriptionTr: Value(data['transcription_tr'] as String?),
              transcriptionEn: Value(data['transcription_en'] as String?),
              translationTr: Value(data['translation_tr'] as String?),
              translationEn: Value(data['translation_en'] as String?),
              sortNumber: data['sort_number'] as int,
            ),
          ),
        );
      });
    } catch (e) {
      // Silently fail - caching is best-effort
    }
  }

  Future<List<VerseWord>> _getCachedVerseWords(
    int surahId,
    int verseNumber,
  ) async {
    final cached =
        await (_db.select(_db.cachedVerseWords)
              ..where(
                (t) =>
                    t.surahId.equals(surahId) &
                    t.verseNumber.equals(verseNumber),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.sortNumber)]))
            .get();

    return cached.map((c) {
      return VerseWord(
        arabic: c.arabic,
        transcriptionTr: c.transcriptionTr,
        transcriptionEn: c.transcriptionEn,
        translationTr: c.translationTr,
        translationEn: c.translationEn,
        sortNumber: c.sortNumber,
      );
    }).toList();
  }

  Future<List<Note>> getNotes(int surahId) {
    return (_db.select(
      _db.notes,
    )..where((t) => t.surahId.equals(surahId))).get();
  }

  Future<Note?> getNoteForVerse(int surahId, int verseNumber) {
    return (_db.select(_db.notes)..where(
          (t) => t.surahId.equals(surahId) & t.verseNumber.equals(verseNumber),
        ))
        .getSingleOrNull();
  }

  Future<void> saveNote(int surahId, int verseNumber, String content) async {
    final existing = await getNoteForVerse(surahId, verseNumber);
    if (existing != null) {
      await (_db.update(_db.notes)..where((t) => t.id.equals(existing.id)))
          .write(NotesCompanion(content: Value(content)));
    } else {
      await _db
          .into(_db.notes)
          .insert(
            NotesCompanion(
              surahId: Value(surahId),
              verseNumber: Value(verseNumber),
              content: Value(content),
            ),
          );
    }
  }

  Future<void> deleteNote(int id) {
    return (_db.delete(_db.notes)..where((t) => t.id.equals(id))).go();
  }

  // Downloaded Translations Management
  Future<List<DownloadedTranslation>> getDownloadedTranslations() {
    return _db.select(_db.downloadedTranslations).get();
  }

  Future<bool> isTranslationDownloaded(int authorId) async {
    try {
      // Check the actual downloaded translations database (DatabaseHelper)
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'quran_translations.db');

      // Check if database exists
      final dbFile = File(path);
      if (!await dbFile.exists()) {
        return false;
      }

      final db = await openDatabase(path);
      try {
        final result = await db.query(
          'downloaded_authors',
          where: 'author_id = ?',
          whereArgs: [authorId],
        );
        return result.isNotEmpty;
      } finally {
        await db.close();
      }
    } catch (e) {
      print('Error checking if translation downloaded: $e');
      return false;
    }
  }

  Future<void> saveDownloadedTranslation({
    required int authorId,
    required String authorName,
    required int totalVerses,
  }) async {
    await _db
        .into(_db.downloadedTranslations)
        .insert(
          DownloadedTranslationsCompanion(
            authorId: Value(authorId),
            authorName: Value(authorName),
            downloadDate: Value(DateTime.now()),
            totalVerses: Value(totalVerses),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  Future<void> deleteDownloadedTranslation(int authorId) async {
    await (_db.delete(
      _db.downloadedTranslations,
    )..where((t) => t.authorId.equals(authorId))).go();
  }

  // Download and cache translation for a specific author and verse
  Future<void> cacheTranslationForVerse({
    required int surahId,
    required int verseNumber,
    required int authorId,
  }) async {
    try {
      final translationsData = await _api.getVerseTranslations(
        surahId,
        verseNumber,
      );

      // Find the translation for the specified author
      final authorTranslation = translationsData.firstWhere(
        (data) => data['author']['id'] == authorId,
        orElse: () => {},
      );

      if (authorTranslation.isEmpty) return;

      // Get the verse ID from database
      final verse =
          await (_db.select(_db.verses)..where(
                (t) =>
                    t.surahId.equals(surahId) &
                    t.verseNumber.equals(verseNumber),
              ))
              .getSingleOrNull();

      if (verse == null) return;

      // Save translation to database
      await _db
          .into(_db.translations)
          .insert(
            TranslationsCompanion(
              verseId: Value(verse.id),
              authorId: Value(authorId),
              content: Value(authorTranslation['text']),
            ),
            mode: InsertMode.insertOrReplace,
          );
    } catch (e) {
      // Silently fail - translation just won't be cached
    }
  }
}

class SurahWithVerses {
  final Surah surah;
  final List<Verse> verses;

  SurahWithVerses(this.surah, this.verses);
}

class TranslationWithAuthor {
  final Translation translation;
  final Author author;

  TranslationWithAuthor(this.translation, this.author);
}

class VerseWord {
  final String arabic;
  final String? transcriptionTr;
  final String? transcriptionEn;
  final String? translationTr;
  final String? translationEn;
  final int sortNumber;

  VerseWord({
    required this.arabic,
    this.transcriptionTr,
    this.transcriptionEn,
    this.translationTr,
    this.translationEn,
    required this.sortNumber,
  });
}
