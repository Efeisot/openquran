// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameOriginalMeta = const VerificationMeta(
    'nameOriginal',
  );
  @override
  late final GeneratedColumn<String> nameOriginal = GeneratedColumn<String>(
    'name_original',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  @override
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageNumberMeta = const VerificationMeta(
    'pageNumber',
  );
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
    'page_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioMeta = const VerificationMeta('audio');
  @override
  late final GeneratedColumn<String> audio = GeneratedColumn<String>(
    'audio',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameEn,
    nameOriginal,
    slug,
    verseCount,
    pageNumber,
    audio,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Surah> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_original')) {
      context.handle(
        _nameOriginalMeta,
        nameOriginal.isAcceptableOrUnknown(
          data['name_original']!,
          _nameOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameOriginalMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    } else if (isInserting) {
      context.missing(_verseCountMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
        _pageNumberMeta,
        pageNumber.isAcceptableOrUnknown(data['page_number']!, _pageNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('audio')) {
      context.handle(
        _audioMeta,
        audio.isAcceptableOrUnknown(data['audio']!, _audioMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      nameOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_original'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
      pageNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_number'],
      )!,
      audio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio'],
      ),
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final int id;
  final String name;
  final String nameEn;
  final String nameOriginal;
  final String slug;
  final int verseCount;
  final int pageNumber;
  final String? audio;
  const Surah({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameOriginal,
    required this.slug,
    required this.verseCount,
    required this.pageNumber,
    this.audio,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['name_en'] = Variable<String>(nameEn);
    map['name_original'] = Variable<String>(nameOriginal);
    map['slug'] = Variable<String>(slug);
    map['verse_count'] = Variable<int>(verseCount);
    map['page_number'] = Variable<int>(pageNumber);
    if (!nullToAbsent || audio != null) {
      map['audio'] = Variable<String>(audio);
    }
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      id: Value(id),
      name: Value(name),
      nameEn: Value(nameEn),
      nameOriginal: Value(nameOriginal),
      slug: Value(slug),
      verseCount: Value(verseCount),
      pageNumber: Value(pageNumber),
      audio: audio == null && nullToAbsent
          ? const Value.absent()
          : Value(audio),
    );
  }

  factory Surah.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameOriginal: serializer.fromJson<String>(json['nameOriginal']),
      slug: serializer.fromJson<String>(json['slug']),
      verseCount: serializer.fromJson<int>(json['verseCount']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      audio: serializer.fromJson<String?>(json['audio']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameOriginal': serializer.toJson<String>(nameOriginal),
      'slug': serializer.toJson<String>(slug),
      'verseCount': serializer.toJson<int>(verseCount),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'audio': serializer.toJson<String?>(audio),
    };
  }

  Surah copyWith({
    int? id,
    String? name,
    String? nameEn,
    String? nameOriginal,
    String? slug,
    int? verseCount,
    int? pageNumber,
    Value<String?> audio = const Value.absent(),
  }) => Surah(
    id: id ?? this.id,
    name: name ?? this.name,
    nameEn: nameEn ?? this.nameEn,
    nameOriginal: nameOriginal ?? this.nameOriginal,
    slug: slug ?? this.slug,
    verseCount: verseCount ?? this.verseCount,
    pageNumber: pageNumber ?? this.pageNumber,
    audio: audio.present ? audio.value : this.audio,
  );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameOriginal: data.nameOriginal.present
          ? data.nameOriginal.value
          : this.nameOriginal,
      slug: data.slug.present ? data.slug.value : this.slug,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
      pageNumber: data.pageNumber.present
          ? data.pageNumber.value
          : this.pageNumber,
      audio: data.audio.present ? data.audio.value : this.audio,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameOriginal: $nameOriginal, ')
          ..write('slug: $slug, ')
          ..write('verseCount: $verseCount, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('audio: $audio')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameEn,
    nameOriginal,
    slug,
    verseCount,
    pageNumber,
    audio,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameEn == this.nameEn &&
          other.nameOriginal == this.nameOriginal &&
          other.slug == this.slug &&
          other.verseCount == this.verseCount &&
          other.pageNumber == this.pageNumber &&
          other.audio == this.audio);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> nameEn;
  final Value<String> nameOriginal;
  final Value<String> slug;
  final Value<int> verseCount;
  final Value<int> pageNumber;
  final Value<String?> audio;
  const SurahsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameOriginal = const Value.absent(),
    this.slug = const Value.absent(),
    this.verseCount = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.audio = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String nameEn,
    required String nameOriginal,
    required String slug,
    required int verseCount,
    required int pageNumber,
    this.audio = const Value.absent(),
  }) : name = Value(name),
       nameEn = Value(nameEn),
       nameOriginal = Value(nameOriginal),
       slug = Value(slug),
       verseCount = Value(verseCount),
       pageNumber = Value(pageNumber);
  static Insertable<Surah> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameEn,
    Expression<String>? nameOriginal,
    Expression<String>? slug,
    Expression<int>? verseCount,
    Expression<int>? pageNumber,
    Expression<String>? audio,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameEn != null) 'name_en': nameEn,
      if (nameOriginal != null) 'name_original': nameOriginal,
      if (slug != null) 'slug': slug,
      if (verseCount != null) 'verse_count': verseCount,
      if (pageNumber != null) 'page_number': pageNumber,
      if (audio != null) 'audio': audio,
    });
  }

  SurahsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? nameEn,
    Value<String>? nameOriginal,
    Value<String>? slug,
    Value<int>? verseCount,
    Value<int>? pageNumber,
    Value<String?>? audio,
  }) {
    return SurahsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameOriginal: nameOriginal ?? this.nameOriginal,
      slug: slug ?? this.slug,
      verseCount: verseCount ?? this.verseCount,
      pageNumber: pageNumber ?? this.pageNumber,
      audio: audio ?? this.audio,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameOriginal.present) {
      map['name_original'] = Variable<String>(nameOriginal.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (audio.present) {
      map['audio'] = Variable<String>(audio.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameOriginal: $nameOriginal, ')
          ..write('slug: $slug, ')
          ..write('verseCount: $verseCount, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('audio: $audio')
          ..write(')'))
        .toString();
  }
}

class $VersesTable extends Verses with TableInfo<$VersesTable, Verse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES surahs (id)',
    ),
  );
  static const VerificationMeta _verseNumberMeta = const VerificationMeta(
    'verseNumber',
  );
  @override
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
    'verse_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<String> verse = GeneratedColumn<String>(
    'verse',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseSimplifiedMeta = const VerificationMeta(
    'verseSimplified',
  );
  @override
  late final GeneratedColumn<String> verseSimplified = GeneratedColumn<String>(
    'verse_simplified',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _juzNumberMeta = const VerificationMeta(
    'juzNumber',
  );
  @override
  late final GeneratedColumn<int> juzNumber = GeneratedColumn<int>(
    'juz_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transcriptionMeta = const VerificationMeta(
    'transcription',
  );
  @override
  late final GeneratedColumn<String> transcription = GeneratedColumn<String>(
    'transcription',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahId,
    verseNumber,
    verse,
    verseSimplified,
    page,
    juzNumber,
    transcription,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'verses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Verse> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_id')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('verse_number')) {
      context.handle(
        _verseNumberMeta,
        verseNumber.isAcceptableOrUnknown(
          data['verse_number']!,
          _verseNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verseNumberMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('verse_simplified')) {
      context.handle(
        _verseSimplifiedMeta,
        verseSimplified.isAcceptableOrUnknown(
          data['verse_simplified']!,
          _verseSimplifiedMeta,
        ),
      );
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('juz_number')) {
      context.handle(
        _juzNumberMeta,
        juzNumber.isAcceptableOrUnknown(data['juz_number']!, _juzNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_juzNumberMeta);
    }
    if (data.containsKey('transcription')) {
      context.handle(
        _transcriptionMeta,
        transcription.isAcceptableOrUnknown(
          data['transcription']!,
          _transcriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Verse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Verse(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_id'],
      )!,
      verseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_number'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verse'],
      )!,
      verseSimplified: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verse_simplified'],
      ),
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      juzNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}juz_number'],
      )!,
      transcription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transcription'],
      ),
    );
  }

  @override
  $VersesTable createAlias(String alias) {
    return $VersesTable(attachedDatabase, alias);
  }
}

class Verse extends DataClass implements Insertable<Verse> {
  final int id;
  final int surahId;
  final int verseNumber;
  final String verse;
  final String? verseSimplified;
  final int page;
  final int juzNumber;
  final String? transcription;
  const Verse({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    required this.verse,
    this.verseSimplified,
    required this.page,
    required this.juzNumber,
    this.transcription,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_id'] = Variable<int>(surahId);
    map['verse_number'] = Variable<int>(verseNumber);
    map['verse'] = Variable<String>(verse);
    if (!nullToAbsent || verseSimplified != null) {
      map['verse_simplified'] = Variable<String>(verseSimplified);
    }
    map['page'] = Variable<int>(page);
    map['juz_number'] = Variable<int>(juzNumber);
    if (!nullToAbsent || transcription != null) {
      map['transcription'] = Variable<String>(transcription);
    }
    return map;
  }

  VersesCompanion toCompanion(bool nullToAbsent) {
    return VersesCompanion(
      id: Value(id),
      surahId: Value(surahId),
      verseNumber: Value(verseNumber),
      verse: Value(verse),
      verseSimplified: verseSimplified == null && nullToAbsent
          ? const Value.absent()
          : Value(verseSimplified),
      page: Value(page),
      juzNumber: Value(juzNumber),
      transcription: transcription == null && nullToAbsent
          ? const Value.absent()
          : Value(transcription),
    );
  }

  factory Verse.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Verse(
      id: serializer.fromJson<int>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      verse: serializer.fromJson<String>(json['verse']),
      verseSimplified: serializer.fromJson<String?>(json['verseSimplified']),
      page: serializer.fromJson<int>(json['page']),
      juzNumber: serializer.fromJson<int>(json['juzNumber']),
      transcription: serializer.fromJson<String?>(json['transcription']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahId': serializer.toJson<int>(surahId),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'verse': serializer.toJson<String>(verse),
      'verseSimplified': serializer.toJson<String?>(verseSimplified),
      'page': serializer.toJson<int>(page),
      'juzNumber': serializer.toJson<int>(juzNumber),
      'transcription': serializer.toJson<String?>(transcription),
    };
  }

  Verse copyWith({
    int? id,
    int? surahId,
    int? verseNumber,
    String? verse,
    Value<String?> verseSimplified = const Value.absent(),
    int? page,
    int? juzNumber,
    Value<String?> transcription = const Value.absent(),
  }) => Verse(
    id: id ?? this.id,
    surahId: surahId ?? this.surahId,
    verseNumber: verseNumber ?? this.verseNumber,
    verse: verse ?? this.verse,
    verseSimplified: verseSimplified.present
        ? verseSimplified.value
        : this.verseSimplified,
    page: page ?? this.page,
    juzNumber: juzNumber ?? this.juzNumber,
    transcription: transcription.present
        ? transcription.value
        : this.transcription,
  );
  Verse copyWithCompanion(VersesCompanion data) {
    return Verse(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      verseNumber: data.verseNumber.present
          ? data.verseNumber.value
          : this.verseNumber,
      verse: data.verse.present ? data.verse.value : this.verse,
      verseSimplified: data.verseSimplified.present
          ? data.verseSimplified.value
          : this.verseSimplified,
      page: data.page.present ? data.page.value : this.page,
      juzNumber: data.juzNumber.present ? data.juzNumber.value : this.juzNumber,
      transcription: data.transcription.present
          ? data.transcription.value
          : this.transcription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Verse(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('verse: $verse, ')
          ..write('verseSimplified: $verseSimplified, ')
          ..write('page: $page, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('transcription: $transcription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surahId,
    verseNumber,
    verse,
    verseSimplified,
    page,
    juzNumber,
    transcription,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Verse &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.verseNumber == this.verseNumber &&
          other.verse == this.verse &&
          other.verseSimplified == this.verseSimplified &&
          other.page == this.page &&
          other.juzNumber == this.juzNumber &&
          other.transcription == this.transcription);
}

class VersesCompanion extends UpdateCompanion<Verse> {
  final Value<int> id;
  final Value<int> surahId;
  final Value<int> verseNumber;
  final Value<String> verse;
  final Value<String?> verseSimplified;
  final Value<int> page;
  final Value<int> juzNumber;
  final Value<String?> transcription;
  const VersesCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.verse = const Value.absent(),
    this.verseSimplified = const Value.absent(),
    this.page = const Value.absent(),
    this.juzNumber = const Value.absent(),
    this.transcription = const Value.absent(),
  });
  VersesCompanion.insert({
    this.id = const Value.absent(),
    required int surahId,
    required int verseNumber,
    required String verse,
    this.verseSimplified = const Value.absent(),
    required int page,
    required int juzNumber,
    this.transcription = const Value.absent(),
  }) : surahId = Value(surahId),
       verseNumber = Value(verseNumber),
       verse = Value(verse),
       page = Value(page),
       juzNumber = Value(juzNumber);
  static Insertable<Verse> custom({
    Expression<int>? id,
    Expression<int>? surahId,
    Expression<int>? verseNumber,
    Expression<String>? verse,
    Expression<String>? verseSimplified,
    Expression<int>? page,
    Expression<int>? juzNumber,
    Expression<String>? transcription,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surah_id': surahId,
      if (verseNumber != null) 'verse_number': verseNumber,
      if (verse != null) 'verse': verse,
      if (verseSimplified != null) 'verse_simplified': verseSimplified,
      if (page != null) 'page': page,
      if (juzNumber != null) 'juz_number': juzNumber,
      if (transcription != null) 'transcription': transcription,
    });
  }

  VersesCompanion copyWith({
    Value<int>? id,
    Value<int>? surahId,
    Value<int>? verseNumber,
    Value<String>? verse,
    Value<String?>? verseSimplified,
    Value<int>? page,
    Value<int>? juzNumber,
    Value<String?>? transcription,
  }) {
    return VersesCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      verseNumber: verseNumber ?? this.verseNumber,
      verse: verse ?? this.verse,
      verseSimplified: verseSimplified ?? this.verseSimplified,
      page: page ?? this.page,
      juzNumber: juzNumber ?? this.juzNumber,
      transcription: transcription ?? this.transcription,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (verseNumber.present) {
      map['verse_number'] = Variable<int>(verseNumber.value);
    }
    if (verse.present) {
      map['verse'] = Variable<String>(verse.value);
    }
    if (verseSimplified.present) {
      map['verse_simplified'] = Variable<String>(verseSimplified.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (juzNumber.present) {
      map['juz_number'] = Variable<int>(juzNumber.value);
    }
    if (transcription.present) {
      map['transcription'] = Variable<String>(transcription.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VersesCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('verse: $verse, ')
          ..write('verseSimplified: $verseSimplified, ')
          ..write('page: $page, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('transcription: $transcription')
          ..write(')'))
        .toString();
  }
}

class $AuthorsTable extends Authors with TableInfo<$AuthorsTable, Author> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, language];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'authors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Author> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Author map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Author(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
    );
  }

  @override
  $AuthorsTable createAlias(String alias) {
    return $AuthorsTable(attachedDatabase, alias);
  }
}

class Author extends DataClass implements Insertable<Author> {
  final int id;
  final String name;
  final String? description;
  final String language;
  const Author({
    required this.id,
    required this.name,
    this.description,
    required this.language,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['language'] = Variable<String>(language);
    return map;
  }

  AuthorsCompanion toCompanion(bool nullToAbsent) {
    return AuthorsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      language: Value(language),
    );
  }

  factory Author.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Author(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      language: serializer.fromJson<String>(json['language']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'language': serializer.toJson<String>(language),
    };
  }

  Author copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? language,
  }) => Author(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    language: language ?? this.language,
  );
  Author copyWithCompanion(AuthorsCompanion data) {
    return Author(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      language: data.language.present ? data.language.value : this.language,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Author(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, language);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Author &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.language == this.language);
}

class AuthorsCompanion extends UpdateCompanion<Author> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> language;
  const AuthorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.language = const Value.absent(),
  });
  AuthorsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required String language,
  }) : name = Value(name),
       language = Value(language);
  static Insertable<Author> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? language,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (language != null) 'language': language,
    });
  }

  AuthorsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? language,
  }) {
    return AuthorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      language: language ?? this.language,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('language: $language')
          ..write(')'))
        .toString();
  }
}

class $TranslationsTable extends Translations
    with TableInfo<$TranslationsTable, Translation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _verseIdMeta = const VerificationMeta(
    'verseId',
  );
  @override
  late final GeneratedColumn<int> verseId = GeneratedColumn<int>(
    'verse_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES verses (id)',
    ),
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<int> authorId = GeneratedColumn<int>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES authors (id)',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, verseId, authorId, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Translation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('verse_id')) {
      context.handle(
        _verseIdMeta,
        verseId.isAcceptableOrUnknown(data['verse_id']!, _verseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_verseIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Translation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Translation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      verseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}author_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
    );
  }

  @override
  $TranslationsTable createAlias(String alias) {
    return $TranslationsTable(attachedDatabase, alias);
  }
}

class Translation extends DataClass implements Insertable<Translation> {
  final int id;
  final int verseId;
  final int authorId;
  final String content;
  const Translation({
    required this.id,
    required this.verseId,
    required this.authorId,
    required this.content,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['verse_id'] = Variable<int>(verseId);
    map['author_id'] = Variable<int>(authorId);
    map['content'] = Variable<String>(content);
    return map;
  }

  TranslationsCompanion toCompanion(bool nullToAbsent) {
    return TranslationsCompanion(
      id: Value(id),
      verseId: Value(verseId),
      authorId: Value(authorId),
      content: Value(content),
    );
  }

  factory Translation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translation(
      id: serializer.fromJson<int>(json['id']),
      verseId: serializer.fromJson<int>(json['verseId']),
      authorId: serializer.fromJson<int>(json['authorId']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'verseId': serializer.toJson<int>(verseId),
      'authorId': serializer.toJson<int>(authorId),
      'content': serializer.toJson<String>(content),
    };
  }

  Translation copyWith({
    int? id,
    int? verseId,
    int? authorId,
    String? content,
  }) => Translation(
    id: id ?? this.id,
    verseId: verseId ?? this.verseId,
    authorId: authorId ?? this.authorId,
    content: content ?? this.content,
  );
  Translation copyWithCompanion(TranslationsCompanion data) {
    return Translation(
      id: data.id.present ? data.id.value : this.id,
      verseId: data.verseId.present ? data.verseId.value : this.verseId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Translation(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('authorId: $authorId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, verseId, authorId, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translation &&
          other.id == this.id &&
          other.verseId == this.verseId &&
          other.authorId == this.authorId &&
          other.content == this.content);
}

class TranslationsCompanion extends UpdateCompanion<Translation> {
  final Value<int> id;
  final Value<int> verseId;
  final Value<int> authorId;
  final Value<String> content;
  const TranslationsCompanion({
    this.id = const Value.absent(),
    this.verseId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.content = const Value.absent(),
  });
  TranslationsCompanion.insert({
    this.id = const Value.absent(),
    required int verseId,
    required int authorId,
    required String content,
  }) : verseId = Value(verseId),
       authorId = Value(authorId),
       content = Value(content);
  static Insertable<Translation> custom({
    Expression<int>? id,
    Expression<int>? verseId,
    Expression<int>? authorId,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (verseId != null) 'verse_id': verseId,
      if (authorId != null) 'author_id': authorId,
      if (content != null) 'content': content,
    });
  }

  TranslationsCompanion copyWith({
    Value<int>? id,
    Value<int>? verseId,
    Value<int>? authorId,
    Value<String>? content,
  }) {
    return TranslationsCompanion(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      authorId: authorId ?? this.authorId,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (verseId.present) {
      map['verse_id'] = Variable<int>(verseId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<int>(authorId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsCompanion(')
          ..write('id: $id, ')
          ..write('verseId: $verseId, ')
          ..write('authorId: $authorId, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseNumberMeta = const VerificationMeta(
    'verseNumber',
  );
  @override
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
    'verse_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahId,
    verseNumber,
    content,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_id')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('verse_number')) {
      context.handle(
        _verseNumberMeta,
        verseNumber.isAcceptableOrUnknown(
          data['verse_number']!,
          _verseNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verseNumberMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_id'],
      )!,
      verseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_number'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final int id;
  final int surahId;
  final int verseNumber;
  final String? content;
  final DateTime createdAt;
  const Note({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_id'] = Variable<int>(surahId);
    map['verse_number'] = Variable<int>(verseNumber);
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      surahId: Value(surahId),
      verseNumber: Value(verseNumber),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<int>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      content: serializer.fromJson<String?>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahId': serializer.toJson<int>(surahId),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'content': serializer.toJson<String?>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Note copyWith({
    int? id,
    int? surahId,
    int? verseNumber,
    Value<String?> content = const Value.absent(),
    DateTime? createdAt,
  }) => Note(
    id: id ?? this.id,
    surahId: surahId ?? this.surahId,
    verseNumber: verseNumber ?? this.verseNumber,
    content: content.present ? content.value : this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      verseNumber: data.verseNumber.present
          ? data.verseNumber.value
          : this.verseNumber,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahId, verseNumber, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.verseNumber == this.verseNumber &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<int> id;
  final Value<int> surahId;
  final Value<int> verseNumber;
  final Value<String?> content;
  final Value<DateTime> createdAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required int surahId,
    required int verseNumber,
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : surahId = Value(surahId),
       verseNumber = Value(verseNumber);
  static Insertable<Note> custom({
    Expression<int>? id,
    Expression<int>? surahId,
    Expression<int>? verseNumber,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surah_id': surahId,
      if (verseNumber != null) 'verse_number': verseNumber,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<int>? surahId,
    Value<int>? verseNumber,
    Value<String?>? content,
    Value<DateTime>? createdAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      verseNumber: verseNumber ?? this.verseNumber,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (verseNumber.present) {
      map['verse_number'] = Variable<int>(verseNumber.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadedTranslationsTable extends DownloadedTranslations
    with TableInfo<$DownloadedTranslationsTable, DownloadedTranslation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedTranslationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<int> authorId = GeneratedColumn<int>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES authors (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _authorNameMeta = const VerificationMeta(
    'authorName',
  );
  @override
  late final GeneratedColumn<String> authorName = GeneratedColumn<String>(
    'author_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _downloadDateMeta = const VerificationMeta(
    'downloadDate',
  );
  @override
  late final GeneratedColumn<DateTime> downloadDate = GeneratedColumn<DateTime>(
    'download_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _totalVersesMeta = const VerificationMeta(
    'totalVerses',
  );
  @override
  late final GeneratedColumn<int> totalVerses = GeneratedColumn<int>(
    'total_verses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    authorId,
    authorName,
    downloadDate,
    totalVerses,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_translations';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadedTranslation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    }
    if (data.containsKey('author_name')) {
      context.handle(
        _authorNameMeta,
        authorName.isAcceptableOrUnknown(data['author_name']!, _authorNameMeta),
      );
    } else if (isInserting) {
      context.missing(_authorNameMeta);
    }
    if (data.containsKey('download_date')) {
      context.handle(
        _downloadDateMeta,
        downloadDate.isAcceptableOrUnknown(
          data['download_date']!,
          _downloadDateMeta,
        ),
      );
    }
    if (data.containsKey('total_verses')) {
      context.handle(
        _totalVersesMeta,
        totalVerses.isAcceptableOrUnknown(
          data['total_verses']!,
          _totalVersesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalVersesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {authorId};
  @override
  DownloadedTranslation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedTranslation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}author_id'],
      )!,
      authorName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author_name'],
      )!,
      downloadDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}download_date'],
      )!,
      totalVerses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_verses'],
      )!,
    );
  }

  @override
  $DownloadedTranslationsTable createAlias(String alias) {
    return $DownloadedTranslationsTable(attachedDatabase, alias);
  }
}

class DownloadedTranslation extends DataClass
    implements Insertable<DownloadedTranslation> {
  final int id;
  final int authorId;
  final String authorName;
  final DateTime downloadDate;
  final int totalVerses;
  const DownloadedTranslation({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.downloadDate,
    required this.totalVerses,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['author_id'] = Variable<int>(authorId);
    map['author_name'] = Variable<String>(authorName);
    map['download_date'] = Variable<DateTime>(downloadDate);
    map['total_verses'] = Variable<int>(totalVerses);
    return map;
  }

  DownloadedTranslationsCompanion toCompanion(bool nullToAbsent) {
    return DownloadedTranslationsCompanion(
      id: Value(id),
      authorId: Value(authorId),
      authorName: Value(authorName),
      downloadDate: Value(downloadDate),
      totalVerses: Value(totalVerses),
    );
  }

  factory DownloadedTranslation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedTranslation(
      id: serializer.fromJson<int>(json['id']),
      authorId: serializer.fromJson<int>(json['authorId']),
      authorName: serializer.fromJson<String>(json['authorName']),
      downloadDate: serializer.fromJson<DateTime>(json['downloadDate']),
      totalVerses: serializer.fromJson<int>(json['totalVerses']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'authorId': serializer.toJson<int>(authorId),
      'authorName': serializer.toJson<String>(authorName),
      'downloadDate': serializer.toJson<DateTime>(downloadDate),
      'totalVerses': serializer.toJson<int>(totalVerses),
    };
  }

  DownloadedTranslation copyWith({
    int? id,
    int? authorId,
    String? authorName,
    DateTime? downloadDate,
    int? totalVerses,
  }) => DownloadedTranslation(
    id: id ?? this.id,
    authorId: authorId ?? this.authorId,
    authorName: authorName ?? this.authorName,
    downloadDate: downloadDate ?? this.downloadDate,
    totalVerses: totalVerses ?? this.totalVerses,
  );
  DownloadedTranslation copyWithCompanion(
    DownloadedTranslationsCompanion data,
  ) {
    return DownloadedTranslation(
      id: data.id.present ? data.id.value : this.id,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      authorName: data.authorName.present
          ? data.authorName.value
          : this.authorName,
      downloadDate: data.downloadDate.present
          ? data.downloadDate.value
          : this.downloadDate,
      totalVerses: data.totalVerses.present
          ? data.totalVerses.value
          : this.totalVerses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedTranslation(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('downloadDate: $downloadDate, ')
          ..write('totalVerses: $totalVerses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, authorId, authorName, downloadDate, totalVerses);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedTranslation &&
          other.id == this.id &&
          other.authorId == this.authorId &&
          other.authorName == this.authorName &&
          other.downloadDate == this.downloadDate &&
          other.totalVerses == this.totalVerses);
}

class DownloadedTranslationsCompanion
    extends UpdateCompanion<DownloadedTranslation> {
  final Value<int> id;
  final Value<int> authorId;
  final Value<String> authorName;
  final Value<DateTime> downloadDate;
  final Value<int> totalVerses;
  const DownloadedTranslationsCompanion({
    this.id = const Value.absent(),
    this.authorId = const Value.absent(),
    this.authorName = const Value.absent(),
    this.downloadDate = const Value.absent(),
    this.totalVerses = const Value.absent(),
  });
  DownloadedTranslationsCompanion.insert({
    required int id,
    this.authorId = const Value.absent(),
    required String authorName,
    this.downloadDate = const Value.absent(),
    required int totalVerses,
  }) : id = Value(id),
       authorName = Value(authorName),
       totalVerses = Value(totalVerses);
  static Insertable<DownloadedTranslation> custom({
    Expression<int>? id,
    Expression<int>? authorId,
    Expression<String>? authorName,
    Expression<DateTime>? downloadDate,
    Expression<int>? totalVerses,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (authorId != null) 'author_id': authorId,
      if (authorName != null) 'author_name': authorName,
      if (downloadDate != null) 'download_date': downloadDate,
      if (totalVerses != null) 'total_verses': totalVerses,
    });
  }

  DownloadedTranslationsCompanion copyWith({
    Value<int>? id,
    Value<int>? authorId,
    Value<String>? authorName,
    Value<DateTime>? downloadDate,
    Value<int>? totalVerses,
  }) {
    return DownloadedTranslationsCompanion(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      downloadDate: downloadDate ?? this.downloadDate,
      totalVerses: totalVerses ?? this.totalVerses,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<int>(authorId.value);
    }
    if (authorName.present) {
      map['author_name'] = Variable<String>(authorName.value);
    }
    if (downloadDate.present) {
      map['download_date'] = Variable<DateTime>(downloadDate.value);
    }
    if (totalVerses.present) {
      map['total_verses'] = Variable<int>(totalVerses.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedTranslationsCompanion(')
          ..write('id: $id, ')
          ..write('authorId: $authorId, ')
          ..write('authorName: $authorName, ')
          ..write('downloadDate: $downloadDate, ')
          ..write('totalVerses: $totalVerses')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $VersesTable verses = $VersesTable(this);
  late final $AuthorsTable authors = $AuthorsTable(this);
  late final $TranslationsTable translations = $TranslationsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $DownloadedTranslationsTable downloadedTranslations =
      $DownloadedTranslationsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    surahs,
    verses,
    authors,
    translations,
    notes,
    downloadedTranslations,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'authors',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('downloaded_translations', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SurahsTableCreateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      required String name,
      required String nameEn,
      required String nameOriginal,
      required String slug,
      required int verseCount,
      required int pageNumber,
      Value<String?> audio,
    });
typedef $$SurahsTableUpdateCompanionBuilder =
    SurahsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> nameEn,
      Value<String> nameOriginal,
      Value<String> slug,
      Value<int> verseCount,
      Value<int> pageNumber,
      Value<String?> audio,
    });

final class $$SurahsTableReferences
    extends BaseReferences<_$AppDatabase, $SurahsTable, Surah> {
  $$SurahsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$VersesTable, List<Verse>> _versesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.verses,
    aliasName: $_aliasNameGenerator(db.surahs.id, db.verses.surahId),
  );

  $$VersesTableProcessedTableManager get versesRefs {
    final manager = $$VersesTableTableManager(
      $_db,
      $_db.verses,
    ).filter((f) => f.surahId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_versesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SurahsTableFilterComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameOriginal => $composableBuilder(
    column: $table.nameOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audio => $composableBuilder(
    column: $table.audio,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> versesRefs(
    Expression<bool> Function($$VersesTableFilterComposer f) f,
  ) {
    final $$VersesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.surahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VersesTableFilterComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahsTableOrderingComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameOriginal => $composableBuilder(
    column: $table.nameOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audio => $composableBuilder(
    column: $table.audio,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SurahsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameOriginal => $composableBuilder(
    column: $table.nameOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageNumber => $composableBuilder(
    column: $table.pageNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audio =>
      $composableBuilder(column: $table.audio, builder: (column) => column);

  Expression<T> versesRefs<T extends Object>(
    Expression<T> Function($$VersesTableAnnotationComposer a) f,
  ) {
    final $$VersesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.surahId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VersesTableAnnotationComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SurahsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SurahsTable,
          Surah,
          $$SurahsTableFilterComposer,
          $$SurahsTableOrderingComposer,
          $$SurahsTableAnnotationComposer,
          $$SurahsTableCreateCompanionBuilder,
          $$SurahsTableUpdateCompanionBuilder,
          (Surah, $$SurahsTableReferences),
          Surah,
          PrefetchHooks Function({bool versesRefs})
        > {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SurahsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SurahsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SurahsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> nameOriginal = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
                Value<int> pageNumber = const Value.absent(),
                Value<String?> audio = const Value.absent(),
              }) => SurahsCompanion(
                id: id,
                name: name,
                nameEn: nameEn,
                nameOriginal: nameOriginal,
                slug: slug,
                verseCount: verseCount,
                pageNumber: pageNumber,
                audio: audio,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String nameEn,
                required String nameOriginal,
                required String slug,
                required int verseCount,
                required int pageNumber,
                Value<String?> audio = const Value.absent(),
              }) => SurahsCompanion.insert(
                id: id,
                name: name,
                nameEn: nameEn,
                nameOriginal: nameOriginal,
                slug: slug,
                verseCount: verseCount,
                pageNumber: pageNumber,
                audio: audio,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SurahsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({versesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (versesRefs) db.verses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (versesRefs)
                    await $_getPrefetchedData<Surah, $SurahsTable, Verse>(
                      currentTable: table,
                      referencedTable: $$SurahsTableReferences._versesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$SurahsTableReferences(db, table, p0).versesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.surahId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SurahsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SurahsTable,
      Surah,
      $$SurahsTableFilterComposer,
      $$SurahsTableOrderingComposer,
      $$SurahsTableAnnotationComposer,
      $$SurahsTableCreateCompanionBuilder,
      $$SurahsTableUpdateCompanionBuilder,
      (Surah, $$SurahsTableReferences),
      Surah,
      PrefetchHooks Function({bool versesRefs})
    >;
typedef $$VersesTableCreateCompanionBuilder =
    VersesCompanion Function({
      Value<int> id,
      required int surahId,
      required int verseNumber,
      required String verse,
      Value<String?> verseSimplified,
      required int page,
      required int juzNumber,
      Value<String?> transcription,
    });
typedef $$VersesTableUpdateCompanionBuilder =
    VersesCompanion Function({
      Value<int> id,
      Value<int> surahId,
      Value<int> verseNumber,
      Value<String> verse,
      Value<String?> verseSimplified,
      Value<int> page,
      Value<int> juzNumber,
      Value<String?> transcription,
    });

final class $$VersesTableReferences
    extends BaseReferences<_$AppDatabase, $VersesTable, Verse> {
  $$VersesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SurahsTable _surahIdTable(_$AppDatabase db) => db.surahs.createAlias(
    $_aliasNameGenerator(db.verses.surahId, db.surahs.id),
  );

  $$SurahsTableProcessedTableManager get surahId {
    final $_column = $_itemColumn<int>('surah_id')!;

    final manager = $$SurahsTableTableManager(
      $_db,
      $_db.surahs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_surahIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TranslationsTable, List<Translation>>
  _translationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.translations,
    aliasName: $_aliasNameGenerator(db.verses.id, db.translations.verseId),
  );

  $$TranslationsTableProcessedTableManager get translationsRefs {
    final manager = $$TranslationsTableTableManager(
      $_db,
      $_db.translations,
    ).filter((f) => f.verseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_translationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VersesTableFilterComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verseSimplified => $composableBuilder(
    column: $table.verseSimplified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get juzNumber => $composableBuilder(
    column: $table.juzNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transcription => $composableBuilder(
    column: $table.transcription,
    builder: (column) => ColumnFilters(column),
  );

  $$SurahsTableFilterComposer get surahId {
    final $$SurahsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableFilterComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> translationsRefs(
    Expression<bool> Function($$TranslationsTableFilterComposer f) f,
  ) {
    final $$TranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.verseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationsTableFilterComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VersesTableOrderingComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verseSimplified => $composableBuilder(
    column: $table.verseSimplified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get juzNumber => $composableBuilder(
    column: $table.juzNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transcription => $composableBuilder(
    column: $table.transcription,
    builder: (column) => ColumnOrderings(column),
  );

  $$SurahsTableOrderingComposer get surahId {
    final $$SurahsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableOrderingComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VersesTable> {
  $$VersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get verseSimplified => $composableBuilder(
    column: $table.verseSimplified,
    builder: (column) => column,
  );

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<int> get juzNumber =>
      $composableBuilder(column: $table.juzNumber, builder: (column) => column);

  GeneratedColumn<String> get transcription => $composableBuilder(
    column: $table.transcription,
    builder: (column) => column,
  );

  $$SurahsTableAnnotationComposer get surahId {
    final $$SurahsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.surahId,
      referencedTable: $db.surahs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SurahsTableAnnotationComposer(
            $db: $db,
            $table: $db.surahs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> translationsRefs<T extends Object>(
    Expression<T> Function($$TranslationsTableAnnotationComposer a) f,
  ) {
    final $$TranslationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.verseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationsTableAnnotationComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VersesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VersesTable,
          Verse,
          $$VersesTableFilterComposer,
          $$VersesTableOrderingComposer,
          $$VersesTableAnnotationComposer,
          $$VersesTableCreateCompanionBuilder,
          $$VersesTableUpdateCompanionBuilder,
          (Verse, $$VersesTableReferences),
          Verse,
          PrefetchHooks Function({bool surahId, bool translationsRefs})
        > {
  $$VersesTableTableManager(_$AppDatabase db, $VersesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahId = const Value.absent(),
                Value<int> verseNumber = const Value.absent(),
                Value<String> verse = const Value.absent(),
                Value<String?> verseSimplified = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<int> juzNumber = const Value.absent(),
                Value<String?> transcription = const Value.absent(),
              }) => VersesCompanion(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                verse: verse,
                verseSimplified: verseSimplified,
                page: page,
                juzNumber: juzNumber,
                transcription: transcription,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahId,
                required int verseNumber,
                required String verse,
                Value<String?> verseSimplified = const Value.absent(),
                required int page,
                required int juzNumber,
                Value<String?> transcription = const Value.absent(),
              }) => VersesCompanion.insert(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                verse: verse,
                verseSimplified: verseSimplified,
                page: page,
                juzNumber: juzNumber,
                transcription: transcription,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$VersesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({surahId = false, translationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (translationsRefs) db.translations],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (surahId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.surahId,
                                referencedTable: $$VersesTableReferences
                                    ._surahIdTable(db),
                                referencedColumn: $$VersesTableReferences
                                    ._surahIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (translationsRefs)
                    await $_getPrefetchedData<Verse, $VersesTable, Translation>(
                      currentTable: table,
                      referencedTable: $$VersesTableReferences
                          ._translationsRefsTable(db),
                      managerFromTypedResult: (p0) => $$VersesTableReferences(
                        db,
                        table,
                        p0,
                      ).translationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.verseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$VersesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VersesTable,
      Verse,
      $$VersesTableFilterComposer,
      $$VersesTableOrderingComposer,
      $$VersesTableAnnotationComposer,
      $$VersesTableCreateCompanionBuilder,
      $$VersesTableUpdateCompanionBuilder,
      (Verse, $$VersesTableReferences),
      Verse,
      PrefetchHooks Function({bool surahId, bool translationsRefs})
    >;
typedef $$AuthorsTableCreateCompanionBuilder =
    AuthorsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required String language,
    });
typedef $$AuthorsTableUpdateCompanionBuilder =
    AuthorsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<String> language,
    });

final class $$AuthorsTableReferences
    extends BaseReferences<_$AppDatabase, $AuthorsTable, Author> {
  $$AuthorsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TranslationsTable, List<Translation>>
  _translationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.translations,
    aliasName: $_aliasNameGenerator(db.authors.id, db.translations.authorId),
  );

  $$TranslationsTableProcessedTableManager get translationsRefs {
    final manager = $$TranslationsTableTableManager(
      $_db,
      $_db.translations,
    ).filter((f) => f.authorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_translationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $DownloadedTranslationsTable,
    List<DownloadedTranslation>
  >
  _downloadedTranslationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.downloadedTranslations,
        aliasName: $_aliasNameGenerator(
          db.authors.id,
          db.downloadedTranslations.authorId,
        ),
      );

  $$DownloadedTranslationsTableProcessedTableManager
  get downloadedTranslationsRefs {
    final manager = $$DownloadedTranslationsTableTableManager(
      $_db,
      $_db.downloadedTranslations,
    ).filter((f) => f.authorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _downloadedTranslationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AuthorsTableFilterComposer
    extends Composer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> translationsRefs(
    Expression<bool> Function($$TranslationsTableFilterComposer f) f,
  ) {
    final $$TranslationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.authorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationsTableFilterComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> downloadedTranslationsRefs(
    Expression<bool> Function($$DownloadedTranslationsTableFilterComposer f) f,
  ) {
    final $$DownloadedTranslationsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.downloadedTranslations,
          getReferencedColumn: (t) => t.authorId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DownloadedTranslationsTableFilterComposer(
                $db: $db,
                $table: $db.downloadedTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AuthorsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthorsTable> {
  $$AuthorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  Expression<T> translationsRefs<T extends Object>(
    Expression<T> Function($$TranslationsTableAnnotationComposer a) f,
  ) {
    final $$TranslationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.translations,
      getReferencedColumn: (t) => t.authorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TranslationsTableAnnotationComposer(
            $db: $db,
            $table: $db.translations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> downloadedTranslationsRefs<T extends Object>(
    Expression<T> Function($$DownloadedTranslationsTableAnnotationComposer a) f,
  ) {
    final $$DownloadedTranslationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.downloadedTranslations,
          getReferencedColumn: (t) => t.authorId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$DownloadedTranslationsTableAnnotationComposer(
                $db: $db,
                $table: $db.downloadedTranslations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AuthorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthorsTable,
          Author,
          $$AuthorsTableFilterComposer,
          $$AuthorsTableOrderingComposer,
          $$AuthorsTableAnnotationComposer,
          $$AuthorsTableCreateCompanionBuilder,
          $$AuthorsTableUpdateCompanionBuilder,
          (Author, $$AuthorsTableReferences),
          Author,
          PrefetchHooks Function({
            bool translationsRefs,
            bool downloadedTranslationsRefs,
          })
        > {
  $$AuthorsTableTableManager(_$AppDatabase db, $AuthorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> language = const Value.absent(),
              }) => AuthorsCompanion(
                id: id,
                name: name,
                description: description,
                language: language,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required String language,
              }) => AuthorsCompanion.insert(
                id: id,
                name: name,
                description: description,
                language: language,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AuthorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({translationsRefs = false, downloadedTranslationsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (translationsRefs) db.translations,
                    if (downloadedTranslationsRefs) db.downloadedTranslations,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (translationsRefs)
                        await $_getPrefetchedData<
                          Author,
                          $AuthorsTable,
                          Translation
                        >(
                          currentTable: table,
                          referencedTable: $$AuthorsTableReferences
                              ._translationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AuthorsTableReferences(
                                db,
                                table,
                                p0,
                              ).translationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.authorId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (downloadedTranslationsRefs)
                        await $_getPrefetchedData<
                          Author,
                          $AuthorsTable,
                          DownloadedTranslation
                        >(
                          currentTable: table,
                          referencedTable: $$AuthorsTableReferences
                              ._downloadedTranslationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AuthorsTableReferences(
                                db,
                                table,
                                p0,
                              ).downloadedTranslationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.authorId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AuthorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthorsTable,
      Author,
      $$AuthorsTableFilterComposer,
      $$AuthorsTableOrderingComposer,
      $$AuthorsTableAnnotationComposer,
      $$AuthorsTableCreateCompanionBuilder,
      $$AuthorsTableUpdateCompanionBuilder,
      (Author, $$AuthorsTableReferences),
      Author,
      PrefetchHooks Function({
        bool translationsRefs,
        bool downloadedTranslationsRefs,
      })
    >;
typedef $$TranslationsTableCreateCompanionBuilder =
    TranslationsCompanion Function({
      Value<int> id,
      required int verseId,
      required int authorId,
      required String content,
    });
typedef $$TranslationsTableUpdateCompanionBuilder =
    TranslationsCompanion Function({
      Value<int> id,
      Value<int> verseId,
      Value<int> authorId,
      Value<String> content,
    });

final class $$TranslationsTableReferences
    extends BaseReferences<_$AppDatabase, $TranslationsTable, Translation> {
  $$TranslationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VersesTable _verseIdTable(_$AppDatabase db) => db.verses.createAlias(
    $_aliasNameGenerator(db.translations.verseId, db.verses.id),
  );

  $$VersesTableProcessedTableManager get verseId {
    final $_column = $_itemColumn<int>('verse_id')!;

    final manager = $$VersesTableTableManager(
      $_db,
      $_db.verses,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_verseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AuthorsTable _authorIdTable(_$AppDatabase db) =>
      db.authors.createAlias(
        $_aliasNameGenerator(db.translations.authorId, db.authors.id),
      );

  $$AuthorsTableProcessedTableManager get authorId {
    final $_column = $_itemColumn<int>('author_id')!;

    final manager = $$AuthorsTableTableManager(
      $_db,
      $_db.authors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_authorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  $$VersesTableFilterComposer get verseId {
    final $$VersesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verseId,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VersesTableFilterComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AuthorsTableFilterComposer get authorId {
    final $$AuthorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorId,
      referencedTable: $db.authors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthorsTableFilterComposer(
            $db: $db,
            $table: $db.authors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  $$VersesTableOrderingComposer get verseId {
    final $$VersesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verseId,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VersesTableOrderingComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AuthorsTableOrderingComposer get authorId {
    final $$AuthorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorId,
      referencedTable: $db.authors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthorsTableOrderingComposer(
            $db: $db,
            $table: $db.authors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TranslationsTable> {
  $$TranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $$VersesTableAnnotationComposer get verseId {
    final $$VersesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.verseId,
      referencedTable: $db.verses,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VersesTableAnnotationComposer(
            $db: $db,
            $table: $db.verses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AuthorsTableAnnotationComposer get authorId {
    final $$AuthorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorId,
      referencedTable: $db.authors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthorsTableAnnotationComposer(
            $db: $db,
            $table: $db.authors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TranslationsTable,
          Translation,
          $$TranslationsTableFilterComposer,
          $$TranslationsTableOrderingComposer,
          $$TranslationsTableAnnotationComposer,
          $$TranslationsTableCreateCompanionBuilder,
          $$TranslationsTableUpdateCompanionBuilder,
          (Translation, $$TranslationsTableReferences),
          Translation,
          PrefetchHooks Function({bool verseId, bool authorId})
        > {
  $$TranslationsTableTableManager(_$AppDatabase db, $TranslationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TranslationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TranslationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TranslationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> verseId = const Value.absent(),
                Value<int> authorId = const Value.absent(),
                Value<String> content = const Value.absent(),
              }) => TranslationsCompanion(
                id: id,
                verseId: verseId,
                authorId: authorId,
                content: content,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int verseId,
                required int authorId,
                required String content,
              }) => TranslationsCompanion.insert(
                id: id,
                verseId: verseId,
                authorId: authorId,
                content: content,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({verseId = false, authorId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (verseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.verseId,
                                referencedTable: $$TranslationsTableReferences
                                    ._verseIdTable(db),
                                referencedColumn: $$TranslationsTableReferences
                                    ._verseIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (authorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.authorId,
                                referencedTable: $$TranslationsTableReferences
                                    ._authorIdTable(db),
                                referencedColumn: $$TranslationsTableReferences
                                    ._authorIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TranslationsTable,
      Translation,
      $$TranslationsTableFilterComposer,
      $$TranslationsTableOrderingComposer,
      $$TranslationsTableAnnotationComposer,
      $$TranslationsTableCreateCompanionBuilder,
      $$TranslationsTableUpdateCompanionBuilder,
      (Translation, $$TranslationsTableReferences),
      Translation,
      PrefetchHooks Function({bool verseId, bool authorId})
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      required int surahId,
      required int verseNumber,
      Value<String?> content,
      Value<DateTime> createdAt,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<int> id,
      Value<int> surahId,
      Value<int> verseNumber,
      Value<String?> content,
      Value<DateTime> createdAt,
    });

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahId = const Value.absent(),
                Value<int> verseNumber = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                content: content,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahId,
                required int verseNumber,
                Value<String?> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                surahId: surahId,
                verseNumber: verseNumber,
                content: content,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$DownloadedTranslationsTableCreateCompanionBuilder =
    DownloadedTranslationsCompanion Function({
      required int id,
      Value<int> authorId,
      required String authorName,
      Value<DateTime> downloadDate,
      required int totalVerses,
    });
typedef $$DownloadedTranslationsTableUpdateCompanionBuilder =
    DownloadedTranslationsCompanion Function({
      Value<int> id,
      Value<int> authorId,
      Value<String> authorName,
      Value<DateTime> downloadDate,
      Value<int> totalVerses,
    });

final class $$DownloadedTranslationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DownloadedTranslationsTable,
          DownloadedTranslation
        > {
  $$DownloadedTranslationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AuthorsTable _authorIdTable(_$AppDatabase db) =>
      db.authors.createAlias(
        $_aliasNameGenerator(db.downloadedTranslations.authorId, db.authors.id),
      );

  $$AuthorsTableProcessedTableManager get authorId {
    final $_column = $_itemColumn<int>('author_id')!;

    final manager = $$AuthorsTableTableManager(
      $_db,
      $_db.authors,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_authorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DownloadedTranslationsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedTranslationsTable> {
  $$DownloadedTranslationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get downloadDate => $composableBuilder(
    column: $table.downloadDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalVerses => $composableBuilder(
    column: $table.totalVerses,
    builder: (column) => ColumnFilters(column),
  );

  $$AuthorsTableFilterComposer get authorId {
    final $$AuthorsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorId,
      referencedTable: $db.authors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthorsTableFilterComposer(
            $db: $db,
            $table: $db.authors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadedTranslationsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedTranslationsTable> {
  $$DownloadedTranslationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get downloadDate => $composableBuilder(
    column: $table.downloadDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalVerses => $composableBuilder(
    column: $table.totalVerses,
    builder: (column) => ColumnOrderings(column),
  );

  $$AuthorsTableOrderingComposer get authorId {
    final $$AuthorsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorId,
      referencedTable: $db.authors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthorsTableOrderingComposer(
            $db: $db,
            $table: $db.authors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadedTranslationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedTranslationsTable> {
  $$DownloadedTranslationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get authorName => $composableBuilder(
    column: $table.authorName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get downloadDate => $composableBuilder(
    column: $table.downloadDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalVerses => $composableBuilder(
    column: $table.totalVerses,
    builder: (column) => column,
  );

  $$AuthorsTableAnnotationComposer get authorId {
    final $$AuthorsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorId,
      referencedTable: $db.authors,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AuthorsTableAnnotationComposer(
            $db: $db,
            $table: $db.authors,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadedTranslationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadedTranslationsTable,
          DownloadedTranslation,
          $$DownloadedTranslationsTableFilterComposer,
          $$DownloadedTranslationsTableOrderingComposer,
          $$DownloadedTranslationsTableAnnotationComposer,
          $$DownloadedTranslationsTableCreateCompanionBuilder,
          $$DownloadedTranslationsTableUpdateCompanionBuilder,
          (DownloadedTranslation, $$DownloadedTranslationsTableReferences),
          DownloadedTranslation,
          PrefetchHooks Function({bool authorId})
        > {
  $$DownloadedTranslationsTableTableManager(
    _$AppDatabase db,
    $DownloadedTranslationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedTranslationsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$DownloadedTranslationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DownloadedTranslationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> authorId = const Value.absent(),
                Value<String> authorName = const Value.absent(),
                Value<DateTime> downloadDate = const Value.absent(),
                Value<int> totalVerses = const Value.absent(),
              }) => DownloadedTranslationsCompanion(
                id: id,
                authorId: authorId,
                authorName: authorName,
                downloadDate: downloadDate,
                totalVerses: totalVerses,
              ),
          createCompanionCallback:
              ({
                required int id,
                Value<int> authorId = const Value.absent(),
                required String authorName,
                Value<DateTime> downloadDate = const Value.absent(),
                required int totalVerses,
              }) => DownloadedTranslationsCompanion.insert(
                id: id,
                authorId: authorId,
                authorName: authorName,
                downloadDate: downloadDate,
                totalVerses: totalVerses,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DownloadedTranslationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({authorId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (authorId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.authorId,
                                referencedTable:
                                    $$DownloadedTranslationsTableReferences
                                        ._authorIdTable(db),
                                referencedColumn:
                                    $$DownloadedTranslationsTableReferences
                                        ._authorIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DownloadedTranslationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadedTranslationsTable,
      DownloadedTranslation,
      $$DownloadedTranslationsTableFilterComposer,
      $$DownloadedTranslationsTableOrderingComposer,
      $$DownloadedTranslationsTableAnnotationComposer,
      $$DownloadedTranslationsTableCreateCompanionBuilder,
      $$DownloadedTranslationsTableUpdateCompanionBuilder,
      (DownloadedTranslation, $$DownloadedTranslationsTableReferences),
      DownloadedTranslation,
      PrefetchHooks Function({bool authorId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$VersesTableTableManager get verses =>
      $$VersesTableTableManager(_db, _db.verses);
  $$AuthorsTableTableManager get authors =>
      $$AuthorsTableTableManager(_db, _db.authors);
  $$TranslationsTableTableManager get translations =>
      $$TranslationsTableTableManager(_db, _db.translations);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$DownloadedTranslationsTableTableManager get downloadedTranslations =>
      $$DownloadedTranslationsTableTableManager(
        _db,
        _db.downloadedTranslations,
      );
}
