import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    // Fetch directly from API instead of local DB
    // This way we don't need verses to be synced first
    final translationsData = await _api.getVerseTranslations(
      surahId,
      verseNumber,
    );

    return translationsData.map<TranslationWithAuthor>((data) {
      final author = Author(
        id: data['author']['id'],
        name: data['author']['name'],
        description: data['author']['description'],
        language: data['author']['language'],
      );

      final translation = Translation(
        id: data['id'],
        verseId: 0, // Not needed for display since we fetch from API
        authorId: data['author']['id'],
        content: data['text'],
      );

      return TranslationWithAuthor(translation, author);
    }).toList();
  }

  Future<List<VerseWord>> getVerseWords(int surahId, int verseNumber) async {
    final wordsData = await _api.getVerseWords(surahId, verseNumber);
    return wordsData.map<VerseWord>((data) {
      return VerseWord(
        arabic: data['arabic'] as String,
        transcriptionTr: data['transcription_tr'] as String?,
        transcriptionEn: data['transcription_en'] as String?,
        translationTr: data['translation_tr'] as String?,
        translationEn: data['translation_en'] as String?,
        sortNumber: data['sort_number'] as int,
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
