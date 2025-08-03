// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MomentImpl _$$MomentImplFromJson(Map<String, dynamic> json) => _$MomentImpl(
  id: (json['id'] as num?)?.toInt(),
  content: json['content'] as String,
  contentType: $enumDecode(_$ContentTypeEnumMap, json['contentType']),
  moods:
      (json['moods'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  aiProcessed: json['aiProcessed'] as bool? ?? false,
);

Map<String, dynamic> _$$MomentImplToJson(_$MomentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'contentType': _$ContentTypeEnumMap[instance.contentType]!,
      'moods': instance.moods,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'aiProcessed': instance.aiProcessed,
    };

const _$ContentTypeEnumMap = {
  ContentType.text: 'text',
  ContentType.voice: 'voice',
  ContentType.image: 'image',
  ContentType.video: 'video',
  ContentType.mixed: 'mixed',
};
