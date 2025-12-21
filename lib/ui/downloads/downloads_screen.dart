import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/repository/quran_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../services/download_notification_manager.dart';

// -----------------------------------------------------------------------------
// 1. MODELLER (Models)
// -----------------------------------------------------------------------------

enum DownloadStatus { initial, downloading, success, error }

class DownloadState {
  final int authorId;
  final int currentSurah; // 1 ile 114 arası
  final double progress; // 0.0 ile 1.0 arası
  final DownloadStatus status;
  final String? errorMessage;

  DownloadState({
    required this.authorId,
    this.currentSurah = 0,
    this.progress = 0.0,
    this.status = DownloadStatus.initial,
    this.errorMessage,
  });

  DownloadState copyWith({
    int? currentSurah,
    double? progress,
    DownloadStatus? status,
    String? errorMessage,
  }) {
    return DownloadState(
      authorId: authorId,
      currentSurah: currentSurah ?? this.currentSurah,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class Author {
  final int id;
  final String name;
  final String language;
  final String? description;

  Author({
    required this.id,
    required this.name,
    required this.language,
    this.description,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      name: json['name'],
      language: json['language'],
      description: json['description'],
    );
  }
}

// -----------------------------------------------------------------------------
// 2. VERİTABANI YARDIMCISI (Database Helper)
// -----------------------------------------------------------------------------

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quran_translations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE verses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah_id INTEGER,
            verse_number INTEGER,
            text TEXT,
            author_id INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE downloaded_authors (
            author_id INTEGER PRIMARY KEY
          )
        ''');
      },
    );
  }

  Future<void> insertSurahBatch(List<dynamic> verses, int authorId) async {
    final db = await instance.database;
    final batch = db.batch();

    for (var verse in verses) {
      String text = "";
      if (verse['translation'] != null &&
          verse['translation']['text'] != null) {
        text = verse['translation']['text'];
      }

      batch.insert('verses', {
        'surah_id': verse['surah_id'],
        'verse_number': verse['verse_number'],
        'text': text,
        'author_id': authorId,
      });
    }

    await batch.commit(noResult: true);
  }

  Future<void> markAuthorAsDownloaded(int authorId) async {
    final db = await instance.database;
    await db.insert('downloaded_authors', {
      'author_id': authorId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteAuthorData(int authorId) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.delete('verses', where: 'author_id = ?', whereArgs: [authorId]);
      await txn.delete(
        'downloaded_authors',
        where: 'author_id = ?',
        whereArgs: [authorId],
      );
    });

    // Reclaim disk space by rebuilding the database file
    await db.execute('VACUUM');
  }

  Future<List<int>> getDownloadedAuthorIds() async {
    final db = await instance.database;
    final result = await db.query('downloaded_authors');
    return result.map((e) => e['author_id'] as int).toList();
  }
}

// -----------------------------------------------------------------------------
// 3. LOGIC & PROVIDERS (Riverpod)
// -----------------------------------------------------------------------------

final authorsListProvider = FutureProvider<List<Author>>((ref) async {
  // Use repository which has offline fallback
  // Use ref.read() instead of ref.watch() to avoid disposal errors
  final repository = ref.read(quranRepositoryProvider);
  final dbAuthors = await repository.getAuthors();

  // Convert database Author to local Author model
  return dbAuthors
      .map(
        (dbAuthor) => Author(
          id: dbAuthor.id,
          name: dbAuthor.name,
          language: dbAuthor.language,
          description: dbAuthor.description,
        ),
      )
      .toList();
});

final downloadedAuthorsProvider = FutureProvider<List<int>>((ref) async {
  return await DatabaseHelper.instance.getDownloadedAuthorIds();
});

// IMPORTANT: Keep the same DownloadManager instance alive
final downloadManagerProvider = Provider((ref) {
  ref.keepAlive(); // Prevent disposal
  return DownloadManager();
});

final downloadStatusProvider = StreamProvider.family<DownloadState, int>((
  ref,
  authorId,
) {
  final manager = ref.watch(downloadManagerProvider);
  return manager.getStatusStream(authorId);
});

class DownloadManager {
  final Dio _dio = Dio();
  final Map<int, StreamController<DownloadState>> _controllers = {};
  final Map<int, DownloadState> _currentStates = {}; // Track current state
  final Map<int, CancelToken> _cancelTokens = {};

  Stream<DownloadState> getStatusStream(int authorId) {
    if (!_controllers.containsKey(authorId)) {
      _controllers[authorId] = StreamController<DownloadState>.broadcast();
      _currentStates[authorId] = DownloadState(authorId: authorId);
    }

    // Create a combined stream: first emit current state, then listen to updates
    return Stream<DownloadState>.multi((controller) {
      // Immediately emit the current state
      controller.add(_currentStates[authorId]!);

      // Then forward all future events
      final subscription = _controllers[authorId]!.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );

      controller.onCancel = () => subscription.cancel();
    });
  }

  void _updateState(int authorId, DownloadState state) {
    _currentStates[authorId] = state;
    _controllers[authorId]?.add(state);
  }

  Future<void> downloadTranslation(int authorId, WidgetRef ref) async {
    // Ensure controller exists
    if (!_controllers.containsKey(authorId)) {
      _controllers[authorId] = StreamController<DownloadState>.broadcast();
      _currentStates[authorId] = DownloadState(authorId: authorId);
    }

    if (_cancelTokens.containsKey(authorId)) return;

    final cancelToken = CancelToken();
    _cancelTokens[authorId] = cancelToken;

    var currentState = DownloadState(
      authorId: authorId,
      status: DownloadStatus.downloading,
      progress: 0.0,
      currentSurah: 0,
    );
    _updateState(authorId, currentState);

    // Request notification permission
    final notificationManager = DownloadNotificationManager.instance;
    await notificationManager.initialize();
    final hasPermission = await notificationManager.requestPermission();

    // Get author name for notifications
    final allAuthors = await ref.read(authorsListProvider.future);
    final author = allAuthors.firstWhere((a) => a.id == authorId);
    final authorName = author.name;

    if (!hasPermission) {
      final errorMessage =
          'Notification permission required for background downloads';
      _updateState(
        authorId,
        currentState.copyWith(
          status: DownloadStatus.error,
          errorMessage: errorMessage,
        ),
      );

      // Show error notification
      await notificationManager.showDownloadError(
        authorId: authorId,
        authorName: authorName,
        error: errorMessage,
      );
      return;
    }

    // Get repository reference BEFORE async operations to avoid disposed widget errors
    QuranRepository? repository;
    try {
      repository = ref.read(quranRepositoryProvider);
    } catch (e) {
      // If widget is already disposed, continue without verse syncing
      print('Warning: Widget disposed, skipping verse sync initialization');
    }

    try {
      for (int surahId = 1; surahId <= 114; surahId++) {
        if (cancelToken.isCancelled) {
          throw DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.cancel,
          );
        }

        final url = 'https://api.acikkuran.com/surah/$surahId?author=$authorId';
        Response? response;
        for (int i = 0; i < 3; i++) {
          try {
            response = await _dio.get(url, cancelToken: cancelToken);
            break;
          } catch (e) {
            if (i == 2) rethrow;
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }

        if (response != null && response.statusCode == 200) {
          final data = response.data['data'];
          final List<dynamic> verses = data['verses'];

          // Save translation verses to DatabaseHelper
          await DatabaseHelper.instance.insertSurahBatch(verses, authorId);

          // ALSO sync Arabic verses to AppDatabase for offline surah viewing
          if (repository != null) {
            try {
              // Sync verses - this will insertOrReplace so it's safe to call multiple times
              await repository.syncSurahDetails(surahId);
            } catch (e) {
              // If syncing fails, continue anyway
              print('Warning: Failed to sync verses to AppDatabase: $e');
            }
          }
        }

        currentState = currentState.copyWith(
          currentSurah: surahId,
          progress: surahId / 114,
        );
        _updateState(authorId, currentState);

        // Update notification with progress
        await notificationManager.showDownloadProgress(
          authorId: authorId,
          authorName: authorName,
          currentSurah: surahId,
          totalSurahs: 114,
        );
      }

      await DatabaseHelper.instance.markAuthorAsDownloaded(authorId);

      // Show completion notification
      await notificationManager.showDownloadComplete(
        authorId: authorId,
        authorName: authorName,
      );

      // Invalidate providers safely (widget might be disposed if backgrounded)
      try {
        ref.invalidate(downloadedAuthorsProvider);
      } catch (e) {
        print('Widget disposed, skipping provider invalidation');
      }

      currentState = currentState.copyWith(
        status: DownloadStatus.success,
        progress: 1.0,
      );
      _updateState(authorId, currentState);
    } catch (e) {
      // Check if it's a cancellation
      if (e is DioException && CancelToken.isCancel(e)) {
        _updateState(
          authorId,
          currentState.copyWith(
            status: DownloadStatus.initial,
            errorMessage: "Download cancelled",
          ),
        );

        // Cancel notification
        await notificationManager.cancelNotification(authorId);
      } else {
        // Handle all other errors (network, parsing, etc.)
        final errorMsg = e is DioException
            ? "Bağlantı hatası: ${e.message ?? e.type.toString()}"
            : "Hata: ${e.toString()}";

        _updateState(
          authorId,
          currentState.copyWith(
            status: DownloadStatus.error,
            errorMessage: errorMsg,
          ),
        );
      }
    } finally {
      _cancelTokens.remove(authorId);
    }
  }

  void cancelDownload(int authorId) {
    _cancelTokens[authorId]?.cancel();
  }

  Future<void> deleteTranslation(int authorId, WidgetRef ref) async {
    await DatabaseHelper.instance.deleteAuthorData(authorId);
    ref.invalidate(downloadedAuthorsProvider);
    _updateState(
      authorId,
      DownloadState(authorId: authorId, status: DownloadStatus.initial),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. UI (User Interface) - MATERIAL 3 STİLİ
// -----------------------------------------------------------------------------

class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authorsAsync = ref.watch(authorsListProvider);
    final downloadedIdsAsync = ref.watch(downloadedAuthorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.downloadTranslations),
        centerTitle: true,
        scrolledUnderElevation: 0, // M3 stili
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(authorsListProvider),
            tooltip: "Listeyi Yenile",
          ),
        ],
      ),
      // M3 arkaplan rengi
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: authorsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Liste yüklenemedi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                err.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(authorsListProvider),
                child: const Text("Tekrar Dene"),
              ),
            ],
          ),
        ),
        data: (authors) {
          return downloadedIdsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const SizedBox(),
            data: (downloadedIds) {
              if (authors.isEmpty) {
                return Center(
                  child: Text(
                    "Listelenecek yazar bulunamadı.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: authors.length,
                itemBuilder: (context, index) {
                  final author = authors[index];
                  final isAlreadyDownloaded = downloadedIds.contains(author.id);

                  return _AuthorMaterialTile(
                    author: author,
                    isAlreadyDownloaded: isAlreadyDownloaded,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _AuthorMaterialTile extends ConsumerWidget {
  final Author author;
  final bool isAlreadyDownloaded;

  const _AuthorMaterialTile({
    required this.author,
    required this.isAlreadyDownloaded,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final downloadStateAsync = ref.watch(downloadStatusProvider(author.id));
    final manager = ref.read(downloadManagerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return downloadStateAsync.when(
      loading: () =>
          _buildCard(context, null, manager, ref, colorScheme, theme, l10n),
      error: (_, _) =>
          _buildCard(context, null, manager, ref, colorScheme, theme, l10n),
      data: (state) =>
          _buildCard(context, state, manager, ref, colorScheme, theme, l10n),
    );
  }

  Widget _buildCard(
    BuildContext context,
    DownloadState? state,
    DownloadManager manager,
    WidgetRef ref,
    ColorScheme colorScheme,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    final status = state?.status ?? DownloadStatus.initial;
    final isCompleted = isAlreadyDownloaded || status == DownloadStatus.success;
    final isDownloading = status == DownloadStatus.downloading;
    final hasError = status == DownloadStatus.error;

    // Card Rengi: İndirildiyse daha belirgin, değilse daha sönük (surfaceContainer)
    final cardColor = isCompleted
        ? colorScheme.secondaryContainer.withValues(alpha: 0.4)
        : colorScheme.surfaceContainerLow;

    final borderColor = isCompleted
        ? colorScheme.outlineVariant
        : Colors.transparent;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Avatar Kısmı with Checkmark Badge
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? colorScheme.secondary
                            : colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        author.language.toUpperCase().substring(0, 2),
                        style: TextStyle(
                          color: isCompleted
                              ? colorScheme.onSecondary
                              : colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    // Checkmark badge for downloaded translations
                    if (isCompleted)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                // Yazı Bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (author.description != null)
                        Text(
                          author.description!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                // Aksiyon Butonu
                _buildActionButton(
                  context,
                  status,
                  isCompleted,
                  isDownloading,
                  manager,
                  ref,
                  colorScheme,
                  l10n,
                ),
              ],
            ),

            // -----------------------------------------------------------------
            // PROGRESS BAR ALANI - ENHANCED VISIBILITY
            // -----------------------------------------------------------------
            if (isDownloading || hasError) ...[
              const SizedBox(height: 16),
              if (hasError)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 20,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state?.errorMessage ?? "Bir hata oluştu",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isDownloading)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Sure ${state?.currentSurah}/114 indiriliyor",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "%${((state?.progress ?? 0) * 100).toInt()}",
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Enhanced Progress Bar with better visibility
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            LinearProgressIndicator(
                              value: state?.progress ?? 0,
                              minHeight: 12,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              color: colorScheme.primary,
                            ),
                            // Shimmer effect overlay
                            if ((state?.progress ?? 0) < 1.0)
                              Positioned.fill(
                                child: LinearProgressIndicator(
                                  minHeight: 12,
                                  backgroundColor: Colors.transparent,
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    DownloadStatus status,
    bool isCompleted,
    bool isDownloading,
    DownloadManager manager,
    WidgetRef ref,
    ColorScheme colorScheme,
    AppLocalizations l10n,
  ) {
    if (isDownloading) {
      return IconButton.filledTonal(
        icon: const Icon(Icons.close_rounded),
        tooltip: l10n.cancel,
        onPressed: () => manager.cancelDownload(author.id),
        style: IconButton.styleFrom(
          backgroundColor: colorScheme.errorContainer,
          foregroundColor: colorScheme.onErrorContainer,
        ),
      );
    }

    if (isCompleted) {
      return IconButton(
        icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
        tooltip: l10n.deleteTranslation,
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.deleteTranslation),
              content: Text(
                "${author.name} mealini cihazdan silmek istiyor musunuz?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Vazgeç"),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    manager.deleteTranslation(author.id, ref);
                  },
                  child: Text(l10n.delete),
                ),
              ],
            ),
          );
        },
      );
    }

    // İndirilmemiş veya Hata durumu
    return IconButton.filled(
      icon: Icon(
        status == DownloadStatus.error
            ? Icons.refresh_rounded
            : Icons.download_rounded,
      ),
      tooltip: l10n.download,
      onPressed: () => manager.downloadTranslation(author.id, ref),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
    );
  }
}
