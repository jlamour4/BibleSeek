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

/// A verse or passage item from a topic. Used for display and voting.
@freezed
abstract class Verse with _$Verse {
  const factory Verse({
    required int id,
    required int startVerseCode,
    int? endVerseCode,
    required String displayRef,
    required String previewText,
    required int voteCount,
    @Default(false) @JsonKey(fromJson: _isFavoritedFromJson) bool isFavorited,
  }) = _Verse;

  factory Verse.fromJson(Map<String, Object?> json) => _$VerseFromJson(json);
}
