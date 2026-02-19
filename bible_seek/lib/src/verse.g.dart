// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Verse _$VerseFromJson(Map<String, dynamic> json) => _Verse(
      id: (json['id'] as num).toInt(),
      startVerseCode: (json['startVerseCode'] as num).toInt(),
      endVerseCode: (json['endVerseCode'] as num?)?.toInt(),
      displayRef: json['displayRef'] as String,
      previewText: json['previewText'] as String,
      voteCount: (json['voteCount'] as num).toInt(),
      isFavorited: json['isFavorited'] == null
          ? false
          : _isFavoritedFromJson(json['isFavorited']),
    );

Map<String, dynamic> _$VerseToJson(_Verse instance) => <String, dynamic>{
      'id': instance.id,
      'startVerseCode': instance.startVerseCode,
      'endVerseCode': instance.endVerseCode,
      'displayRef': instance.displayRef,
      'previewText': instance.previewText,
      'voteCount': instance.voteCount,
      'isFavorited': instance.isFavorited,
    };
