import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  void initState() {
    super.initState();
    // Listen to download progress
    ref.read(downloadManagerProvider).progressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _downloadProgress[progress.authorId] = progress;
        });

        // Clear progress when complete or cancelled
        if (progress.isComplete ||
            progress.isCancelled ||
            progress.error != null) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _downloadProgress.remove(progress.authorId);
              });
            }
          });
        }
      }
    });
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
    final l10n = AppLocalizations.of(context)!;
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
              if (progress != null && !progress.isComplete) ...[
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress.progress),
                const SizedBox(height: 2),
                Text(
                  '${progress.currentSurah}/${progress.totalSurahs} surahs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (progress?.error != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Error: ${progress!.error}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
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
        downloadManager.downloadTranslation(author.id, author.name);
      },
    );
  }
}
