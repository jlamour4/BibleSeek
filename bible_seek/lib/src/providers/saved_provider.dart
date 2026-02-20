import 'package:bible_seek/src/api/authenticated_client.dart';
import 'package:bible_seek/src/config/config.dart';
import 'package:bible_seek/src/verse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Saves or unsaves a topic. POST /api/topics/{topicId}/save (toggle).
Future<void> toggleSaveTopic(String topicId) async {
  final dio = AuthenticatedDio(Dio()).dio;
  await dio.post(
    '${AppConfig.currentHost}/api/topics/$topicId/save',
    options: Options(headers: <String, String>{'Content-Type': 'application/json'}),
  );
}

/// Toggles favorite for a verse. POST /api/topic-verses/{id}/favorite (toggle).
Future<void> toggleFavoriteVerse(int verseId) async {
  final dio = AuthenticatedDio(Dio()).dio;
  await dio.post(
    '${AppConfig.currentHost}/api/topic-verses/$verseId/favorite',
    options: Options(headers: <String, String>{'Content-Type': 'application/json'}),
  );
}

/// Vote types for POST /api/topic-verses/{id}/vote
String _voteTypeFromMyVote(int? current, bool isUpvote) {
  if (isUpvote) return current == 1 ? 'clear' : 'upvote';
  return current == -1 ? 'clear' : 'downvote';
}

/// Format vote API error for display. Call from catch blocks.
String formatVoteError(Object e, [StackTrace? st]) {
  if (e is DioException) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    if (status != null) {
      final detail = data is Map ? (data['message'] ?? data['error'] ?? data['detail']) : null;
      final msg = detail?.toString() ?? '';
      return 'Vote failed ($status)${msg.isNotEmpty ? ': $msg' : ''}';
    }
    return e.message ?? 'Vote failed: ${e.type}';
  }
  return 'Vote failed: $e';
}

/// Votes on a verse. POST /api/topic-verses/{id}/vote
/// Body: {voteType: 'upvote'|'downvote'|'clear'}
/// Returns {voteCount, myVote} for reconciliation.
Future<({int voteCount, int? myVote})> voteVerse(int verseId, int? currentMyVote, bool isUpvote) async {
  final dio = AuthenticatedDio(Dio()).dio;
  final voteType = _voteTypeFromMyVote(currentMyVote, isUpvote);
  final uri = '${AppConfig.currentHost}/api/topic-verses/$verseId/vote';
  final body = {'voteType': voteType};
  debugPrint('[Vote] POST $uri body=$body');
  Response response;
  try {
    response = await dio.post(
      uri,
      data: body,
      options: Options(headers: <String, String>{'Content-Type': 'application/json'}),
    );
  } on DioException catch (e) {
    debugPrint('[Vote] DioException: status=${e.response?.statusCode} data=${e.response?.data}');
    rethrow;
  }
  final data = response.data;
  if (data is Map) {
    final count = (data['voteCount'] as num?)?.toInt();
    final mv = data['myVote'] ?? data['my_vote'];
    int? myVote;
    if (mv != null) {
      if (mv is int) myVote = mv == 0 ? null : (mv > 0 ? 1 : -1);
      else if (mv is String) myVote = mv.toString().toLowerCase() == 'upvote' ? 1 : -1;
    }
    return (voteCount: count ?? 0, myVote: myVote);
  }
  return (voteCount: 0, myVote: null);
}

/// Model for a saved topic (id + name for list display).
class SavedTopic {
  const SavedTopic({required this.id, required this.name});
  final String id;
  final String name;

  factory SavedTopic.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['topicId'] ?? json['topic_id'];
    final name = json['name'] ?? json['label'] ?? json['topicName'] ?? json['topic_name'];
    final nested = json['topic'] as Map?;
    return SavedTopic(
      id: (nested?['id'] ?? nested?['topicId'] ?? id)?.toString() ?? '',
      name: (nested?['name'] ?? nested?['label'] ?? nested?['topicName'] ?? name)?.toString() ?? '',
    );
  }
}

/// Saved passage: verse + topic context for navigation.
class SavedPassage {
  const SavedPassage({
    required this.verse,
    required this.topicId,
    required this.topicName,
  });
  final Verse verse;
  final String topicId;
  final String topicName;

  factory SavedPassage.fromJson(Map<String, dynamic> json) {
    final verseData = json['verse'] as Map? ?? json;
    final v = Map<String, Object?>.from(verseData);
    v['id'] ??= 0;
    v['startVerseCode'] ??= 0;
    v['displayRef'] ??= '';
    v['previewText'] ??= '';
    v['voteCount'] ??= 0;
    v['isFavorited'] ??= v['favorited'] ?? v['isFavourited'] ?? v['favourite'] ?? true;
    if (!v.containsKey('myVote') && v.containsKey('my_vote')) v['myVote'] = v['my_vote'];
    if (!v.containsKey('topicVerseId') && !v.containsKey('topic_verse_id')) {
      v['topicVerseId'] ??= json['topicVerseId'] ?? json['topic_verse_id'];
    } else if (!v.containsKey('topicVerseId') && v.containsKey('topic_verse_id')) {
      v['topicVerseId'] = v['topic_verse_id'];
    }
    final topic = json['topic'] as Map?;
    final topicId = (json['topicId'] ?? v['topicId'] ?? topic?['id'] ?? topic?['topicId'])?.toString() ?? '';
    final topicName = (json['topicName'] ?? v['topicName'] ?? topic?['name'] ?? topic?['topicName'] ?? topic?['label'])?.toString() ?? '';
    return SavedPassage(
      verse: Verse.fromJson(v),
      topicId: topicId,
      topicName: topicName,
    );
  }
}

/// Fetches saved topics. GET /api/me/saved-topics
/// Returns empty list on 404 (endpoint not implemented) or 200 with empty data.
final savedTopicsProvider = FutureProvider.autoDispose<List<SavedTopic>>((ref) async {
  final dio = AuthenticatedDio(Dio()).dio;
  try {
    final response = await dio.get(
      '${AppConfig.currentHost}/api/me/saved-topics',
      options: Options(
        headers: <String, String>{'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 404 || response.statusCode != 200) return [];
    final data = response.data;
    if (data == null) return [];
    final list = data is List ? data : (data is Map && data['items'] != null ? data['items'] : data['topics']);
    if (list is! List) return [];
    return list.map((e) => SavedTopic.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) return [];
    rethrow;
  }
});

/// Fetches saved passages (favorited verses).
///
/// Endpoint: GET /api/me/favorites (SecurityConfig /api/me/**)
/// Response: List<TopicVerseItemDto> — id, previewText, displayRef, voteCount,
/// isFavorited, topicId?, topicName?, etc.
final savedPassagesProvider = FutureProvider.autoDispose<List<SavedPassage>>((ref) async {
  debugPrint('[SavedPassages] Fetching...');
  final dio = AuthenticatedDio(Dio()).dio;
  try {
    final response = await dio.get(
      '${AppConfig.currentHost}${AppConfig.savedVersesPath}',
      options: Options(
        headers: <String, String>{'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    final data = response.data;
    debugPrint('[SavedPassages] Response (${response.statusCode}): $data');
    if (response.statusCode == 404 || response.statusCode != 200) return [];
    if (data == null) return [];
    final list = data is List
        ? data
        : (data is Map
            ? (data['verses'] ?? data['items'] ?? data['favorites'] ?? data['savedVerses'] ?? data['passages'])
            : null);
    if (list is! List) return [];
    final passages = <SavedPassage>[];
    for (final e in list) {
      if (e is Map) {
        try {
          passages.add(SavedPassage.fromJson(Map<String, dynamic>.from(e)));
        } catch (_) {}
      }
    }
    return passages;
  } on DioException catch (e) {
    debugPrint('[SavedPassages] DioException: ${e.response?.statusCode} ${e.response?.data}');
    if (e.response?.statusCode == 404) return [];
    rethrow;
  }
});

/// Locally unsaved verse IDs on Saved screen. Keeps cards visible, heart outline,
/// until refresh. UNDO removes from this set and re-saves.
final locallyUnsavedVerseIdsProvider =
    NotifierProvider<_LocallyUnsavedIdsNotifier, Set<int>>(
  _LocallyUnsavedIdsNotifier.new,
);

class _LocallyUnsavedIdsNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  void add(int verseId) => state = {...state, verseId};
  void remove(int verseId) => state = {...state}..remove(verseId);
  bool contains(int verseId) => state.contains(verseId);
}

/// Whether a topic is saved. Derived from savedTopicsProvider.
bool topicIsSaved(List<SavedTopic> topics, String topicId) {
  return topics.any((t) => t.id == topicId);
}

/// Optimistic bookmark overrides so icon fills immediately when saving.
/// Key: topicId, Value: saved state. Absent = use API result.
final savedTopicOverridesProvider =
    NotifierProvider<_SavedTopicOverridesNotifier, Map<String, bool>>(
  _SavedTopicOverridesNotifier.new,
);

class _SavedTopicOverridesNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() => {};

  void set(String topicId, bool saved) {
    state = {...state, topicId: saved};
  }

  void remove(String topicId) {
    final next = Map<String, bool>.from(state);
    next.remove(topicId);
    state = next;
  }
}

bool isTopicSaved(List<SavedTopic> topics, Map<String, bool> overrides, String topicId) {
  if (overrides.containsKey(topicId)) return overrides[topicId]!;
  return topicIsSaved(topics, topicId);
}

/// Shared favorite overrides so list and detail stay in sync.
/// Key: verseId, Value: favorited state. Absent = use verse.isFavorited.
final favoriteOverridesProvider =
    NotifierProvider<_FavoriteOverridesNotifier, Map<int, bool>>(
  _FavoriteOverridesNotifier.new,
);

class _FavoriteOverridesNotifier extends Notifier<Map<int, bool>> {
  @override
  Map<int, bool> build() => {};

  void set(int verseId, bool favorited) {
    state = {...state, verseId: favorited};
  }

  void remove(int verseId) {
    final next = Map<int, bool>.from(state);
    next.remove(verseId);
    state = next;
  }

  void updateMap(Map<int, bool> Function(Map<int, bool>) fn) {
    state = fn(Map<int, bool>.from(state));
  }
}

bool isVerseFavorited(Verse verse, Map<int, bool> overrides) =>
    overrides[verse.id] ?? verse.isFavorited;

/// Vote overrides: verseId -> (voteCount, myVote). For optimistic UI + server reconciliation.
final voteOverridesProvider =
    NotifierProvider<_VoteOverridesNotifier, Map<int, ({int voteCount, int? myVote})>>(
  _VoteOverridesNotifier.new,
);

class _VoteOverridesNotifier extends Notifier<Map<int, ({int voteCount, int? myVote})>> {
  @override
  Map<int, ({int voteCount, int? myVote})> build() => {};

  void set(int verseId, int voteCount, int? myVote) {
    state = {...state, verseId: (voteCount: voteCount, myVote: myVote)};
  }

  void remove(int verseId) {
    final next = Map<int, ({int voteCount, int? myVote})>.from(state);
    next.remove(verseId);
    state = next;
  }
}

(int voteCount, int? myVote) verseVoteState(Verse verse, Map<int, ({int voteCount, int? myVote})> overrides) {
  final o = overrides[verse.id];
  if (o != null) return (o.voteCount, o.myVote);
  return (verse.voteCount, verse.myVote);
}

/// Optimistic (voteCount, myVote) when toggling vote.
(int, int?) optimisticVote(int currentCount, int? currentMyVote, bool isUpvote) {
  if (isUpvote) {
    if (currentMyVote == 1) return (currentCount - 1, null);
    if (currentMyVote == -1) return (currentCount + 2, 1);
    return (currentCount + 1, 1);
  } else {
    if (currentMyVote == -1) return (currentCount + 1, null);
    if (currentMyVote == 1) return (currentCount - 2, -1);
    return (currentCount - 1, -1);
  }
}
