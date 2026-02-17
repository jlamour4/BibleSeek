// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
      reputation: (json['reputation'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      badgeCounts: json['badgeCounts'] == null
          ? null
          : BadgeCount.fromJson(
              (json['badgeCounts'] as Map<String, dynamic>).map(
              (k, e) => MapEntry(k, e as Object),
            )),
      displayName: json['displayName'] as String,
      profileImage: json['profileImage'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
      'reputation': instance.reputation,
      'userId': instance.userId,
      'badgeCounts': instance.badgeCounts,
      'displayName': instance.displayName,
      'profileImage': instance.profileImage,
      'link': instance.link,
    };

_BadgeCount _$BadgeCountFromJson(Map<String, dynamic> json) => _BadgeCount(
      bronze: (json['bronze'] as num).toInt(),
      silver: (json['silver'] as num).toInt(),
      gold: (json['gold'] as num).toInt(),
    );

Map<String, dynamic> _$BadgeCountToJson(_BadgeCount instance) =>
    <String, dynamic>{
      'bronze': instance.bronze,
      'silver': instance.silver,
      'gold': instance.gold,
    };
