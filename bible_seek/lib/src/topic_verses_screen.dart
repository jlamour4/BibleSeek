import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/design/spacing.dart';
import 'package:bible_seek/src/design/text_styles.dart';
import 'package:bible_seek/src/verse.dart';
import 'package:bible_seek/src/verse_detail_screen.dart';
import 'package:bible_seek/widgets/verse_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provider that fetches full text for a single verse in a topic.
/// GET /api/topics/{topicId}/verses/{itemId}
/// Returns fullText on success; use verse.previewText as fallback when loading or on error.
final verseDetailProvider = FutureProvider.autoDispose
    .family<String, ({String topicId, int itemId})>((ref, params) async {
  final dio = AuthenticatedDio(Dio()).dio;
  final uri =
      '${AppConfig.currentHost}/api/topics/${params.topicId}/verses/${params.itemId}';

  final response = await dio.get(
    uri,
    options: Options(
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );

  if (response.statusCode != 200) {
    throw Exception(
        'Failed to load verse: ${response.statusCode} ${response.statusMessage}');
  }

  final data = response.data;
  if (data is Map && data['fullText'] != null) {
    return data['fullText'] as String;
  }
  if (data is Map && data['previewText'] != null) {
    return data['previewText'] as String;
  }
  throw Exception('Invalid response: missing fullText');
});

/// Provider that fetches verses for a topic. No pagination for now.
/// TODO: Add pagination when backend supports it (e.g. ?page=1&pageSize=50).
final topicVersesProvider =
    FutureProvider.autoDispose.family<List<Verse>, String>((ref, topicId) async {
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
          debugPrint('[TopicVerses] Parse error at index $i: item is not a Map, got ${item.runtimeType}');
          continue;
        }
        verses.add(Verse.fromJson(Map<String, Object?>.from(item)));
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(topicName),
        actions: [
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
          );
        },
      ),
    );
  }
}

class _VerseList extends StatefulWidget {
  const _VerseList({
    required this.verses,
    required this.topicId,
    required this.topicName,
  });

  final List<Verse> verses;
  final String topicId;
  final String topicName;

  @override
  State<_VerseList> createState() => _VerseListState();
}

class _VerseListState extends State<_VerseList> {
  final Set<int> _favoritedIds = {};

  @override
  Widget build(BuildContext context) {
    final bottomPadding =
        MediaQuery.of(context).padding.bottom + AppSpacing.space8;
    return ListView.builder(
      padding: EdgeInsets.only(
        top: AppSpacing.space8,
        bottom: bottomPadding,
      ),
      itemCount: widget.verses.length,
      itemBuilder: (context, index) {
        final v = widget.verses[index];
        return VerseCard(
          displayRef: v.displayRef,
          previewText: v.previewText,
          voteCount: v.voteCount,
          commentCount: 0,
          isFavorited: _favoritedIds.contains(v.id),
          onUpvote: () => debugPrint('[VerseCard] upvote id=${v.id}'),
          onDownvote: () => debugPrint('[VerseCard] downvote id=${v.id}'),
          onFavorite: () {
            setState(() {
              if (_favoritedIds.contains(v.id)) {
                _favoritedIds.remove(v.id);
              } else {
                _favoritedIds.add(v.id);
              }
            });
          },
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
    );
  }
}
