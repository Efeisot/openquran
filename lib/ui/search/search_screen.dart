import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database.dart';
import '../../data/repository/quran_repository.dart';
import '../../l10n/app_localizations.dart';
import '../reading/reading_screen.dart';
import '../../data/local/preferences.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchResult> _results = [];
  bool _isSearching = false;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _query = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _query = query.trim();
    });

    try {
      final results = await _search(query.trim().toLowerCase());
      setState(() {
        _results = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _results = [];
      });
    }
  }

  // Check if query is a verse reference like "1:1" or "2:255"
  bool _isVerseReference(String query) {
    final pattern = RegExp(r'^(\d+):(\d+)$');
    return pattern.hasMatch(query);
  }

  Future<List<SearchResult>> _search(String query) async {
    final repository = ref.read(quranRepositoryProvider);

    // Check if it's a direct verse reference (e.g., "1:1")
    if (_isVerseReference(query)) {
      final parts = query.split(':');
      final surahId = int.tryParse(parts[0]);
      final verseNumber = int.tryParse(parts[1]);

      if (surahId != null && verseNumber != null) {
        try {
          final surahDetails = await repository.getSurahDetails(surahId);
          final verse = surahDetails.verses
              .where((v) => v.verseNumber == verseNumber)
              .firstOrNull;

          if (verse != null) {
            return [
              SearchResult(
                type: SearchResultType.verse,
                surah: surahDetails.surah,
                verse: verse,
              ),
            ];
          }
        } catch (e) {
          // Surah or verse not found
        }
      }
    }

    // Otherwise, perform regular search
    final results = <SearchResult>[];

    // Search surahs
    final surahs = await repository.getSurahs();
    for (final surah in surahs) {
      if (surah.name.toLowerCase().contains(query) ||
          surah.nameEn.toLowerCase().contains(query) ||
          surah.nameOriginal.contains(query)) {
        results.add(SearchResult(type: SearchResultType.surah, surah: surah));
      }
    }

    // Search verses (limit to avoid performance issues)
    // We'll search through all loaded surahs
    for (final surah in surahs.take(10)) {
      try {
        final surahDetails = await repository.getSurahDetails(surah.id);
        for (final verse in surahDetails.verses) {
          if (verse.verse.toLowerCase().contains(query) ||
              (verse.transcription?.toLowerCase().contains(query) ?? false)) {
            results.add(
              SearchResult(
                type: SearchResultType.verse,
                surah: surah,
                verse: verse,
              ),
            );

            // Limit verse results
            if (results.where((r) => r.type == SearchResultType.verse).length >=
                20) {
              break;
            }
          }
        }
      } catch (e) {
        // Skip if surah details not available
      }
    }

    return results;
  }

  Future<Iterable<String>> _getSuggestions(String pattern) async {
    if (pattern.isEmpty) {
      return const Iterable<String>.empty();
    }
    final repository = ref.read(quranRepositoryProvider);
    final suggestions = <String>[];

    // Check if it's a verse reference pattern (e.g., "2:1" or "2:")
    final verseRefPattern = RegExp(r'^(\d+):(\d*)$');
    final match = verseRefPattern.firstMatch(pattern);

    if (match != null) {
      // It's a verse reference like "2:1" or "2:"
      final surahId = int.tryParse(match.group(1)!);
      final verseNum = match.group(2);

      if (surahId != null && surahId >= 1 && surahId <= 114) {
        try {
          final surahDetails = await repository.getSurahDetails(surahId);

          if (verseNum!.isEmpty) {
            // Just "2:" - suggest some verse numbers
            suggestions.add('$surahId:1');
            if (surahDetails.verses.length > 1) suggestions.add('$surahId:2');
            if (surahDetails.verses.length > 4) suggestions.add('$surahId:5');
            if (surahDetails.verses.length > 9) suggestions.add('$surahId:10');
          } else {
            // Complete reference like "2:1"
            suggestions.add(pattern);
          }
        } catch (e) {
          // Surah not found
        }
      }
      return suggestions.take(5);
    }

    // Suggest surah names
    final surahs = await repository.getSurahs();
    for (final surah in surahs) {
      if (surah.name.toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(surah.name);
      }
      if (surah.nameEn.toLowerCase().contains(pattern.toLowerCase())) {
        suggestions.add(surah.nameEn);
      }
      // If pattern is a number, suggest matching surah IDs
      if (RegExp(r'^\d+$').hasMatch(pattern)) {
        final num = int.tryParse(pattern);
        if (num != null && surah.id.toString().startsWith(pattern)) {
          suggestions.add(
            '${surah.id}:1',
          ); // Suggest first verse of matching surahs
        }
      }
    }

    // Limit suggestions
    return suggestions.take(5);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: Theme.of(context).textTheme.titleMedium,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          onChanged: (value) {
            // Trigger search immediately for suggestions
            setState(() {
              _query = value;
            });
            // Debounce actual search
            Future.delayed(const Duration(milliseconds: 500), () {
              if (_searchController.text == value && mounted) {
                _performSearch(value);
              }
            });
          },
          onSubmitted: _performSearch,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _results = [];
                  _query = '';
                });
              },
            ),
        ],
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.searchHint,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Show suggestions inline if query is short and no results yet
    if (_results.isEmpty && _query.length <= 3) {
      return FutureBuilder<Iterable<String>>(
        future: _getSuggestions(_query),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noResults,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final suggestion = snapshot.data!.elementAt(index);
              return ListTile(
                leading: const Icon(Icons.search),
                title: Text(suggestion),
                onTap: () {
                  _searchController.text = suggestion;
                  _performSearch(suggestion);
                },
              );
            },
          );
        },
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noResults,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        return _buildResultTile(result);
      },
    );
  }

  Widget _buildResultTile(SearchResult result) {
    if (result.type == SearchResultType.surah) {
      return ListTile(
        leading: CircleAvatar(child: Text('${result.surah.id}')),
        title: Text(result.surah.name),
        subtitle: Text(result.surah.nameEn),
        trailing: Text(
          result.surah.nameOriginal,
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 20),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadingScreen(surahId: result.surah.id),
            ),
          );
        },
      );
    } else {
      final verse = result.verse!;

      return FutureBuilder<String?>(
        future: () {
          final authorId = ref
              .read(preferencesProvider)
              .getDefaultTranslationAuthorId();
          if (authorId == null) return Future.value(null);
          return ref
              .read(quranRepositoryProvider)
              .getDefaultTranslationForVerse(
                result.surah.id,
                verse.verseNumber,
                authorId,
              );
        }(),
        builder: (context, snapshot) {
          final translation = snapshot.data;

          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Text(
                '${result.surah.id}:${verse.verseNumber}',
                style: const TextStyle(fontSize: 11),
              ),
            ),
            title: Text(
              translation ?? verse.verse,
              style: translation != null
                  ? null
                  : const TextStyle(fontFamily: 'Amiri'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${result.surah.name} - ${AppLocalizations.of(context)!.verse} ${verse.verseNumber}',
                ),
                if (translation != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    verse.verse,
                    style: const TextStyle(fontFamily: 'Amiri', fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            isThreeLine: translation != null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingScreen(
                    surahId: result.surah.id,
                    shouldAutoOpen: true,
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}

enum SearchResultType { surah, verse }

class SearchResult {
  final SearchResultType type;
  final Surah surah;
  final Verse? verse;

  SearchResult({required this.type, required this.surah, this.verse});
}
