import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse.g.dart';
part 'verse.freezed.dart';

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
  }) = _Verse;

  factory Verse.fromJson(Map<String, Object?> json) => _$VerseFromJson(json);
}
