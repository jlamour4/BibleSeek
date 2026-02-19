// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionsResponse _$QuestionsResponseFromJson(Map<String, dynamic> json) =>
    _QuestionsResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$QuestionsResponseToJson(_QuestionsResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'total': instance.total,
    };

_Question _$QuestionFromJson(Map<String, dynamic> json) => _Question(
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      viewCount: (json['viewCount'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      bountyAmount: (json['bountyAmount'] as num?)?.toInt(),
      acceptedAnswerId: (json['acceptedAnswerId'] as num?)?.toInt(),
      owner: User.fromJson((json['owner'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, e as Object),
      )),
      answerCount: (json['answerCount'] as num).toInt(),
      creationDate: const TimestampParser()
          .fromJson((json['creationDate'] as num).toInt()),
      questionId: (json['questionId'] as num).toInt(),
      link: json['link'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$QuestionToJson(_Question instance) => <String, dynamic>{
      'tags': instance.tags,
      'viewCount': instance.viewCount,
      'score': instance.score,
      'bountyAmount': instance.bountyAmount,
      'acceptedAnswerId': instance.acceptedAnswerId,
      'owner': instance.owner,
      'answerCount': instance.answerCount,
      'creationDate': const TimestampParser().toJson(instance.creationDate),
      'questionId': instance.questionId,
      'link': instance.link,
      'title': instance.title,
      'body': instance.body,
    };
