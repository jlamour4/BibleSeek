import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/verse.dart';
import 'package:bible_seek/widgets/topic_item_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  'Error loading verses',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
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
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              return TopicVerseCard(verse: verses[index]);
            },
          );
        },
      ),
    );
  }
}
