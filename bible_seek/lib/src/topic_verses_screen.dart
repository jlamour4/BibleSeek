import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/providers/saved_provider.dart';
import 'package:bible_seek/src/verse.dart';
import 'package:bible_seek/src/verse_detail_screen.dart';
import 'package:bible_seek/widgets/verse_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Normalizes favorite-related JSON keys to isFavorited. Backends may use
/// favorited, isFavourited, favourite, is_favorited, or favorite.
void _normalizeFavoriteKey(Map<String, Object?> map) {
  if (map.containsKey('isFavorited')) return;
  for (final key in ['favorited', 'isFavourited', 'favourite', 'is_favorited', 'favorite']) {
    if (map.containsKey(key)) {
      map['isFavorited'] = map[key];
      return;
    }
  }
}

/// Provider that fetches verses for a topic. No pagination for now.
/// TODO: Add pagination when backend supports it (e.g. ?page=1&pageSize=50).
final topicVersesProvider =
    FutureProvider.autoDispose.family<List<Verse>, String>((ref, topicId) async {
  if (topicId.isEmpty) return [];
  final dio = AuthenticatedDio(Dio()).dio;
  final uri = '${AppConfig.currentHost}/api/topics/$topicId/verses';

  try {
    final response = await dio.get(
      uri,
      options: Options(
        headers: <String, String>{'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load verses: ${response.statusCode} ${response.statusMessage}');
    }

    final data = response.data;
    if (data == null) return <Verse>[];

    List<dynamic> rawList;
    if (data is List) {
      rawList = data;
    } else if (data is Map && data.containsKey('verses')) {
      rawList = data['verses'] as List<dynamic>;
    } else if (data is Map && data.containsKey('items')) {
      rawList = data['items'] as List<dynamic>;
    } else {
      rawList = [];
    }

    final verses = <Verse>[];
    for (var i = 0; i < rawList.length; i++) {
      try {
        final item = rawList[i];
        if (item is! Map) {
          debugPrint(
              '[TopicVerses] Parse error at index $i: item is not a Map, got ${item.runtimeType}');
          continue;
        }
        final map = Map<String, Object?>.from(item);
        _normalizeFavoriteKey(map);
        verses.add(Verse.fromJson(map));
      } catch (e, stack) {
        debugPrint('[TopicVerses] Parse error at index $i: $e');
        debugPrint('[TopicVerses] Raw item: ${rawList[i]}');
        debugPrint('[TopicVerses] Stack: $stack');
      }
    }
    return verses;
  } catch (e, stack) {
    if (e is DioException && e.response != null) {
      debugPrint(
          '[TopicVerses] Parse/HTTP error. Response: ${e.response?.data}');
      debugPrint('[TopicVerses] Status: ${e.response?.statusCode}');
    }
    debugPrint('[TopicVerses] Error: $e');
    debugPrint('[TopicVerses] Stack: $stack');
    rethrow;
  }
});

/// Screen that displays verses for a selected topic.
class TopicVersesScreen extends HookConsumerWidget {
  const TopicVersesScreen({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  final String topicId;
  final String topicName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(topicVersesProvider(topicId));
    final savedTopicsAsync = ref.watch(savedTopicsProvider);
    final savedOverrides = ref.watch(savedTopicOverridesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final savedTopics = savedTopicsAsync.asData?.value ?? [];
    final isSaved = isTopicSaved(savedTopics, savedOverrides, topicId);

    return Scaffold(
      appBar: AppBar(
        title: Text(topicName),
        actions: [
          IconButton(
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: topicId.isEmpty
                ? null
                : () async {
                    final nextSaved = !isSaved;
                    ref.read(savedTopicOverridesProvider.notifier).set(topicId, nextSaved);
                    try {
                      await toggleSaveTopic(topicId);
                      ref.invalidate(savedTopicsProvider);
                    } catch (_) {
                      if (context.mounted) {
                        ref.read(savedTopicOverridesProvider.notifier).remove(topicId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to save topic')),
                        );
                      }
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => debugPrint('[TopicVersesScreen] search'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => debugPrint('[TopicVersesScreen] add'),
          ),
        ],
      ),
      body: versesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                const SizedBox(height: AppSpacing.space16),
                Text(
                  'Error loading verses',
                  style: AppTextStyles.screenTitle(context),
                ),
                const SizedBox(height: AppSpacing.space8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.metaText(context),
                ),
              ],
            ),
          ),
        ),
        data: (verses) {
          if (verses.isEmpty) {
            return Center(
              child: Text(
                'No verses found',
                style: AppTextStyles.bodyText(context),
              ),
            );
          }

          return _VerseList(
            verses: verses,
            topicId: topicId,
            topicName: topicName,
            onFavoriteChange: () => ref.invalidate(savedPassagesProvider),
          );
        },
      ),
    );
  }
}

class _VerseList extends ConsumerStatefulWidget {
  const _VerseList({
    required this.verses,
    required this.topicId,
    required this.topicName,
    this.onFavoriteChange,
  });

  final List<Verse> verses;
  final String topicId;
  final String topicName;
  final VoidCallback? onFavoriteChange;

  @override
  ConsumerState<_VerseList> createState() => _VerseListState();
}

class _VerseListState extends ConsumerState<_VerseList> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOpacity = 0;

  static const double _opacityThreshold = 48;
  static const double _maxOpacity = 0.25;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final opacity = (offset / _opacityThreshold).clamp(0.0, 1.0) * _maxOpacity;
    if (opacity != _scrollOpacity) {
      setState(() => _scrollOpacity = opacity);
    }
  }

  Future<void> _toggleFavorite(Verse v) async {
    final overrides = ref.read(favoriteOverridesProvider);
    final wasFavorited = isVerseFavorited(v, overrides);
    ref.read(favoriteOverridesProvider.notifier).updateMap((m) {
      m[v.id] = !wasFavorited;
      return m;
    });
    try {
      await toggleFavoriteVerse(v.id);
      widget.onFavoriteChange?.call();
    } catch (_) {
      if (mounted) {
        ref.read(favoriteOverridesProvider.notifier).remove(v.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update favorite')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPadding =
        MediaQuery.of(context).padding.bottom + AppSpacing.space24;

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.only(
            top: AppSpacing.space8,
            bottom: bottomPadding,
          ),
          itemCount: widget.verses.length,
          itemBuilder: (context, index) {
            final v = widget.verses[index];
            final overrides = ref.watch(favoriteOverridesProvider);
            return VerseCard(
              key: ValueKey(v.id),
              displayRef: v.displayRef,
              previewText: v.previewText,
              voteCount: v.voteCount,
              commentCount: 0,
              isFavorited: isVerseFavorited(v, overrides),
              onUpvote: () => debugPrint('[VerseCard] upvote id=${v.id}'),
              onDownvote: () => debugPrint('[VerseCard] downvote id=${v.id}'),
              onFavorite: () => _toggleFavorite(v),
              onComment: () => debugPrint('[VerseCard] comment id=${v.id}'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => VerseDetailScreen(
                      topicId: widget.topicId,
                      topicName: widget.topicName,
                      verse: v,
                    ),
                  ),
                );
              },
            );
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Opacity(
              opacity: _scrollOpacity,
              child: Container(
                height: 1,
                color: colorScheme.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
