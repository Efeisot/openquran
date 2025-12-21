import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/download_manager.dart';
import '../../data/repository/quran_repository.dart';
import '../../data/local/database.dart';
import '../../l10n/app_localizations.dart';

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  final Map<int, DownloadProgress?> _downloadProgress = {};
  StreamSubscription<DownloadProgress>? _progressSubscription;

  @override
  void initState() {
    super.initState();
    // Set up listener once after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressSubscription = ref
          .read(downloadManagerProvider)
          .progressStream
          .listen((progress) {
            if (mounted) {
              print(
                'Progress update for author ${progress.authorId}: ${progress.currentSurah}/${progress.totalSurahs}',
              );
              setState(() {
                _downloadProgress[progress.authorId] = progress;
              });

              // Show error as SnackBar
              if (progress.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Download failed: ${progress.error}'),
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () async {
                        final authors = await ref
                            .read(quranRepositoryProvider)
                            .getAuthors();
                        final author = authors.firstWhere(
                          (a) => a.id == progress.authorId,
                        );
                        ref
                            .read(downloadManagerProvider)
                            .downloadTranslation(author.id, author.name);
                      },
                    ),
                  ),
                );
              }

              // Show completion message
              if (progress.isComplete) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Download complete!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }

              // Clear progress when complete, cancelled, or error
              if (progress.isComplete ||
                  progress.isCancelled ||
                  progress.error != null) {
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    setState(() {
                      _downloadProgress.remove(progress.authorId);
                    });
                  }
                });
              }
            }
          });
    });
  }

  @override
  void dispose() {
    _progressSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authorsAsync = ref.watch(quranRepositoryProvider).getAuthors();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.downloadTranslations)),
      body: FutureBuilder(
        future: authorsAsync,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final authors = snapshot.data ?? [];

          return ListView.builder(
            itemCount: authors.length,
            itemBuilder: (context, index) {
              final author = authors[index];
              return _buildAuthorTile(author);
            },
          );
        },
      ),
    );
  }

  Widget _buildAuthorTile(Author author) {
    final downloadManager = ref.read(downloadManagerProvider);
    final progress = _downloadProgress[author.id];

    return FutureBuilder<bool>(
      future: downloadManager.isTranslationDownloaded(author.id),
      builder: (context, snapshot) {
        final isDownloaded = snapshot.data ?? false;

        return ListTile(
          leading: CircleAvatar(
            child: Text(author.language.toUpperCase().substring(0, 2)),
          ),
          title: Text(author.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (author.description != null)
                Text(
                  author.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (progress != null &&
                  !progress.isComplete &&
                  !progress.isCancelled &&
                  progress.error == null) ...[
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress.progress),
                const SizedBox(height: 2),
                Text(
                  'Downloading ${progress.currentSurah}/${progress.totalSurahs} surahs (${(progress.progress * 100).toInt()}%)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (progress?.isCancelled == true) ...[
                const SizedBox(height: 4),
                Text(
                  'Download cancelled',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ],
          ),
          isThreeLine: progress != null || author.description != null,
          trailing: _buildTrailing(author, isDownloaded, progress),
        );
      },
    );
  }

  Widget _buildTrailing(
    Author author,
    bool isDownloaded,
    DownloadProgress? progress,
  ) {
    final downloadManager = ref.read(downloadManagerProvider);

    if (progress != null && !progress.isComplete && !progress.isCancelled) {
      // Downloading
      return IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          downloadManager.cancelDownload(author.id);
        },
      );
    }

    if (isDownloaded) {
      // Downloaded
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.deleteTranslation),
                  content: Text('Delete ${author.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(AppLocalizations.of(context)!.delete),
                    ),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                await downloadManager.deleteTranslation(author.id);
                setState(() {});
              }
            },
          ),
        ],
      );
    }

    // Not downloaded
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: () {
        // Immediately set a progress state to show download is starting
        setState(() {
          _downloadProgress[author.id] = DownloadProgress(
            currentSurah: 0,
            totalSurahs: 114,
            authorId: author.id,
          );
        });
        downloadManager.downloadTranslation(author.id, author.name);
      },
    );
  }
}
