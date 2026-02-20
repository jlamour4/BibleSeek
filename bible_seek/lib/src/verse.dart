import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse.g.dart';
part 'verse.freezed.dart';

bool _isFavoritedFromJson(Object? value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true';
  if (value is int) return value != 0;
  return false;
}

/// Parses myVote from API: 1=upvote, -1=downvote, null=none.
int? _myVoteFromJson(Object? value) {
  if (value == null) return null;
  if (value is int) return value == 0 ? null : (value > 0 ? 1 : -1);
  if (value is String) {
    final s = value.toLowerCase();
    if (s == 'upvote') return 1;
    if (s == 'downvote') return -1;
  }
  return null;
}

/// ID to use for vote/favorite API calls. Prefer [topicVerseId] when present (favorites may use it).
int topicVerseIdForApi(Verse v) => v.topicVerseId ?? v.id;

/// A verse or passage item from a topic. Used for display and voting.
@freezed
abstract class Verse with _$Verse {
  const factory Verse({
    required int id,
    int? topicVerseId,
    required int startVerseCode,
    int? endVerseCode,
    required String displayRef,
    required String previewText,
    required int voteCount,
    @Default(false) @JsonKey(fromJson: _isFavoritedFromJson) bool isFavorited,
    @JsonKey(fromJson: _myVoteFromJson) int? myVote,
  }) = _Verse;

  factory Verse.fromJson(Map<String, Object?> json) => _$VerseFromJson(json);
}
