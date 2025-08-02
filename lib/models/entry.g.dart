// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EntryImpl _$$EntryImplFromJson(Map<String, dynamic> json) => _$EntryImpl(
  id: (json['id'] as num?)?.toInt(),
  content: json['content'] as String,
  contentType: $enumDecode(_$ContentTypeEnumMap, json['contentType']),
  mood: json['mood'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  aiProcessed: json['aiProcessed'] as bool? ?? false,
);

Map<String, dynamic> _$$EntryImplToJson(_$EntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'contentType': _$ContentTypeEnumMap[instance.contentType]!,
      'mood': instance.mood,
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
