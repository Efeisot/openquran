import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

class Surahs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get nameEn => text()();
  TextColumn get nameOriginal => text()();
  TextColumn get slug => text()();
  IntColumn get verseCount => integer()();
  IntColumn get pageNumber => integer()();
  TextColumn get audio => text().nullable()();
}

class Verses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahId => integer().references(Surahs, #id)();
  IntColumn get verseNumber => integer()();
  TextColumn get verse => text()();
  TextColumn get verseSimplified => text().nullable()();
  IntColumn get page => integer()();
  IntColumn get juzNumber => integer()();
  TextColumn get transcription => text().nullable()();
}

class Authors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get language => text()();
}

class Translations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get verseId => integer().references(Verses, #id)();
  IntColumn get authorId => integer().references(Authors, #id)();
  TextColumn get content => text()();
}

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahId => integer()();
  IntColumn get verseNumber => integer()();
  TextColumn get content => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class DownloadedTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get authorId =>
      integer().references(Authors, #id, onDelete: KeyAction.cascade)();
  TextColumn get authorName => text()();
  DateTimeColumn get downloadDate =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get totalVerses => integer()();

  @override
  Set<Column> get primaryKey => {authorId};
}

// Cache translations locally for offline access
class CachedTranslations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahId => integer()();
  IntColumn get verseNumber => integer()();
  IntColumn get authorId => integer()();
  TextColumn get authorName => text()();
  TextColumn get authorDescription => text().nullable()();
  TextColumn get authorLanguage => text()();
  TextColumn get content => text()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
}

// Cache verse words (word-by-word analysis) for offline access
class CachedVerseWords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get surahId => integer()();
  IntColumn get verseNumber => integer()();
  TextColumn get arabic => text()();
  TextColumn get transcriptionTr => text().nullable()();
  TextColumn get transcriptionEn => text().nullable()();
  TextColumn get translationTr => text().nullable()();
  TextColumn get translationEn => text().nullable()();
  IntColumn get sortNumber => integer()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Surahs,
    Verses,
    Authors,
    Translations,
    Notes,
    DownloadedTranslations,
    CachedTranslations,
    CachedVerseWords,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(notes);
        }
        if (from < 3) {
          await m.createTable(downloadedTranslations);
        }
        if (from < 4) {
          await m.createTable(cachedTranslations);
          await m.createTable(cachedVerseWords);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
